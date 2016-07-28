FROM ruby:2.3.1

MAINTAINER dogwood008

ENV API_KEY YourAPIKeyHere
ENV LANGUAGE_CODE ja-JP

# Install sox
RUN apt-get update
RUN apt-get -y install git sudo vorbis-tools sox 

# Time Zone
RUN echo "Asia/Tokyo" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# Boot Server
RUN git clone https://github.com/dogwood008/google_cloud_speech_recognition_sample.git
WORKDIR /google_cloud_speech_recognition_sample
RUN bundle install
CMD bundle exec ruby recog.rb -e production
EXPOSE 4567

