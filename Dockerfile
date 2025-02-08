# ベースイメージ
FROM ruby:3.1

# 作業ディレクトリの設定
WORKDIR /app

# 必要なファイルをコピー
COPY . .

# Bundlerのインストールと依存関係の解決
RUN bundle install

# Sinatraを起動するためのコマンド
CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
