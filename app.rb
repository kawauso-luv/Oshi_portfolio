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
  
  if session[:user].nil? && request.path != '/session_error' && request.path != '/' && request.path != '/signin' && request.path != '/signup' && request.path != '/signout' && !(request.path =~ %r{^/portfolio/\d+$})
    redirect '/session_error' # ログインページへリダイレクト
  end
  
end   

get '/session_error' do
    erb :session_error
end

not_found do
  redirect "/mypage/#{session[:user]}"
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
    redirect "/mypage/#{session[:user]}"
end


post '/signin' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
        session[:user] = user.id
    end
  redirect "/mypage/#{session[:user]}"
end


post '/signout' do
    session.delete(:user)
    redirect '/'
end

get '/record' do
    erb :record
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
    Item.create(
        user_id: session[:user],
        name: params[:name],
        image_url: img_url,
        price: params[:price].to_i,
        category: params[:category],
        genre: params[:genre])
  
  redirect "/mypage/#{session[:user]}"
end

get '/newpost' do
    erb :post
end

post '/newpost' do
    if params[:upload_photo]
        image = params[:upload_photo]
        tempfile = image[:tempfile]
        upload = Cloudinary::Uploader.upload(tempfile.path)
        img_url = upload['url']
    else
        img_url = null
    end  
    post = Post.create(
        image_url: img_url,
        user_name: current_user.name,
        content: params[:content],
        genre: params[:category],
        like: 0
    )
    p post
    redirect '/timeline'
end

get '/timeline' do
    @posts = Post.order(created_at: :desc)
    erb :timeline
end

post '/newportfolio' do
    
    allitems = Item.all
    @items = Item.where(user: session[:user], genre: params[:genre])
    @genre = params[:genre]
    
    @total_price = allitems.sum(:price)
    @genre_price = @items.sum(:price)
    
    @genre_percent = ((@genre_price.to_f / @total_price.to_f) * 100).round(1).to_i
    p "---------"
    p @genre_percent
    erb:newportfolio
end    


post '/makeportfolio' do
    portfolio = Portfolio.create(
        user_id: session[:user],
        color: params[:color],
        genre: params[:genre],
        total_price: params[:total_price],
        genre_price: params[:genre_price],
        genre_percent: params[:genre_percent]
    )
    p portfolio
    redirect "/portfolio/#{portfolio.id}"
end

get '/portfolio/:id' do
    @portfolio = Portfolio.find(params[:id])
    p "================"
    p @portfolio
    p @portfolio.color
    @item = Item.where(genre: @portfolio.genre)
    @percent = 
    
    erb:portfolio
end

get '/allitems' do
    @items = Item.where(user_id: session[:user])
    @genre = @items.map{|item| item.genre}.uniq
    erb:allitems 
end

get '/mypage/:id' do
    @items = Item.where(user_id: session[:user])
    @genre = @items.map{|item| item.genre}.uniq
    @portfolios =Portfolio.where(user_id: session[:user])
    erb :mypage
end