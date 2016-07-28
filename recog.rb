require 'sinatra'
require 'base64'
require 'open3'
require 'json'
require 'net/https'
require 'haml'
require 'openssl'
require 'pry' if $DEBUG

#ENCODING = 'LINEAR16'
ENCODING = 'FLAC'

TMP_FILE_NAME = './tmp'.freeze
OUTPUT_FILE_PATH = File.expand_path('../output.flac', __FILE__)

before do
  @uploaded_file = params[:file]&.fetch(:tempfile)
end

get '/' do
  haml :index
end

post '/recog' do
  tmp_file_path = if params[:submit].index(10.to_s)
                    trim_and_convert(@uploaded_file.path, 0, 10, ENCODING)
                  else
                    convert_only(@uploaded_file.path, ENCODING)
                  end
  req = build_google_api_request_data(tmp_file_path, ENCODING)

  response = execute_http_request(req[:url], req[:data])
  response.body
end

post '/sample_rate' do
  get_sampling_rate(@uploaded_file.path)
end

post '/upload' do
  save_narration(@uploaded_file)
end

private

def execute_http_request(url, data_hash)
  uri = URI.parse(url)
  https = make_net_http(uri, ENV['HTTP_PROXY'])
  req = Net::HTTP::Post.new(uri.request_uri)
  req['Content-Type'] = 'application/json'
  req.body = data_hash.to_json
  res = https.request(req)
end

def initialize_net_http(net_http)
  net_http.use_ssl = true
  net_http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  net_http.verify_depth = 5
  net_http
end

def make_net_http(uri, proxy)
  https = if proxy
            address, port = proxy.split(':')
            proxy = Net::HTTP::Proxy(address, port)
            proxy.new(uri.host, uri.port)
          else
            Net::HTTP.new(uri.host, uri.port)
          end
  initialize_net_http(https)
end

def save_narration(binary_narration_file)
  open(TMP_FILE_NAME, 'wb') do |f|
    f << binary_narration_file.read
  end
end

def convert_only(file_path, encoding)
  FileUtils.rm(OUTPUT_FILE_PATH) rescue nil
  system('sox', file_path, \
         '--rate', '16k', \
         '--bits', '16', \
         '--channels', '1', \
         OUTPUT_FILE_PATH)
  OUTPUT_FILE_PATH
end

def trim_and_convert(file_path, from_sec, to_sec, encoding)
  FileUtils.rm(OUTPUT_FILE_PATH) rescue nil
  system('sox', file_path, \
         '--rate', '16k', \
         '--bits', '16', \
         '--channels', '1', \
         OUTPUT_FILE_PATH, 'trim', from_sec.to_s, to_sec.to_s)
  OUTPUT_FILE_PATH
end

def base64encode(file_path)
  open(file_path, 'rb') do |f|
    Base64.strict_encode64(f.read)
  end
end

def get_sampling_rate(file_path)
  Open3.capture3('soxi', '-r', file_path).first.strip
end

def build_google_api_request_body(sample_rate, base64_encoded_file, encoding)
  {
    config: {
      encoding: encoding,
      sample_rate: sample_rate,
      language_code: ENV['LANGUAGE_CODE'],
      max_alternatives: 1
    },
    audio: {
      content: base64_encoded_file
    }
  }
end

def build_google_api_request_data(file_path, encoding)
  req_body = build_google_api_request_body(get_sampling_rate(file_path), base64encode(file_path), encoding)
  url = "https://speech.googleapis.com/v1beta1/speech:syncrecognize?key=#{ENV['API_KEY']}"
  { url: url, data: req_body }
end


__END__
@@index
%html
  %body
    %form{action: '/recog', method: 'POST', enctype: 'multipart/form-data'}
      %input{type: :file,   name: :file}
      %input{type: :submit, name: :submit, :value => 'upload (recognize 10 secs)'}
      %input{type: :submit, name: :submit, :value => 'upload (!CAUTION! recognize all !CAUTION!)'}
