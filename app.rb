require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
enable :sessions
require 'pry'
# cloudinary関連
require 'cloudinary'
require 'cloudinary/uploader'
require 'cloudinary/utils'
require 'dotenv/load'

helpers do
    def current_user
        User.find_by(id: session[:user])
    end    
end

before do
  Dotenv.load
  Cloudinary.config do |config|
    config.cloud_name = ENV["CLOUD_NAME"]
    config.api_key = ENV["CLOUDINARY_API_KEY"]
    config.api_secret = ENV["CLOUDINARY_API_SECRET"]
  end
end

get '/' do
    erb :index
end


get '/signin' do
    erb :signin
end


post '/signup' do
    user = User.create(name: params[:name], password: params[:password], password_confirmation: params[:password_confirmation], email: params[:email])
    if user.persisted?
        session[:user] = user.id
    end
    redirect "/#{session[:user]}"
end


post '/signin' do
    user = User.find_by(email: params[:email])
    p "========"
    p user.name
    p "========"
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
  redirect "/#{session[:user]}"
end


post '/signout' do
    session.delete(:user)
    redirect '/'
end

get '/record' do
    erb :record
end

get '/:id' do
     @items = Item.all
    p "==========="
    p @items
    erb :mypage
end


post '/record' do
    # params[:image]が空の場合の対処
    img_url = "/img/null_item.jpg"
    if params[:image]
        image = params[:image]
        p image
        tempfile = image[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    end
    # 商品の追加
    item = Item.create(
        name: params[:name],
        image_url: img_url,
        price: params[:price].to_i,
        category: params[:category],
        genre: params[:genre])
  
  redirect "/#{session[:user]}"
end