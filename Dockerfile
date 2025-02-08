# ベースイメージ
FROM ruby:3.3

# 作業ディレクトリの設定
WORKDIR /app

# 必要なファイルをコピー
COPY . .

# Bundlerのインストールと依存関係の解決
RUN bundle install

# Sinatraを起動するためのコマンド
CMD ["rackup", "--host", "0.0.0.0", "--port", "8080"]
