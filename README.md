## What is this project?
This project is test for [Google Cloud Speech API](https://cloud.google.com/speech/). You can use voice recognition via the API. Only you have to do is to get API key and boot machine by docker (or clone this project and boot Sinatra).

## How to setup

### With Docker

1. Download "Dockerfile"
  - `wget https://raw.githubusercontent.com/dogwood008/google_cloud_speech_recognition_sample/master/Dockerfile`
1. Replace by your language in "Dockerfile"
  - `ENV LANGUAGE_CODE ja-JP`
1. Replace by your api key in "Dockerfile"
  - `ENV API_KEY YourAPIKeyHere`
1. Build
  - `docker build -t dogwood008/google_cloud_speech_recognition_sample .`
1. Run
  - `docker run -p 4567:4567 -it dogwood008/google_cloud_speech_recognition_sample`
1. Access
  - `http://localhost:4567`

### Without Docker
1. Clone this repository
  - `git clone https://github.com/dogwood008/google_cloud_speech_recognition_sample.git`
1. Install gems
  - `bundle install`
1. Run with your language and API key
  - `LANGUAGE_CODE=ja-JP API_KEY=your_api_key_here bundle exec ruby recog.rb`
1. Access
  - `http://localhost:4567`

--

## このプロジェクトは何？
[Google Cloud Speech API](https://cloud.google.com/speech/)を使用して、音声認識のテストをすることができます。
必要なのはAPIキーを取得して、Dockerコンテナを起動するだけ（または今プロジェクトクローンしてSinatraを起動する）です。

## セットアップ方法

### Dockerを使う場合

1. "Dockerfile"をダウンロード
  - `wget https://raw.githubusercontent.com/dogwood008/google_cloud_speech_recognition_sample/master/Dockerfile`
1. "Dockerfile"を編集、言語を置換
  - `ENV LANGUAGE_CODE ja-JP`
1. "Dockerfile"を編集、APIキーを置換
  - `ENV API_KEY YourAPIKeyHere`
1. ビルド
  - `docker build -t dogwood008/google_cloud_speech_recognition_sample .`
1. 実行
  - `docker run -p 4567:4567 -it dogwood008/google_cloud_speech_recognition_sample`
1. アクセス
  - `http://localhost:4567`

### Dockerを使わない場合
1. このリポジトリをクローン
  - `git clone https://github.com/dogwood008/google_cloud_speech_recognition_sample.git`
1. gemをインストール
  - `bundle install`
1. 自分の言語とAPIキーを入れて実行
  - `LANGUAGE_CODE=ja-JP API_KEY=your_api_key_here bundle exec ruby recog.rb`
1. アクセス
  - `http://localhost:4567`
