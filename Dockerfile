# ベースイメージ
FROM ruby:3.3

# 必要なパッケージをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs


# 作業ディレクトリの設定
WORKDIR /app

# 必要なファイルをコピー
COPY . .

# Bundlerのインストールと依存関係の解決
RUN bundle install

# Sinatraを起動するためのコマンド
CMD ["rackup", "--host", "0.0.0.0", "--port", "8080"]
