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
        category: params[:category],
        like: 0
    )
    redirect "/#{session[:user]}"
end

get '/timeline' do
    @posts = Post.order(created_at: :desc)
    erb :timeline
end

post '/newportfolio' do
    @genre_of_portfolio = params[:genre]
    
    @items = Item.all
    @genre = @items.where(genre: @genre_of_portfolio)
    
    total_price = @items.sum(:price)
    @genre_price = @genre.sum(:price)
    
    @genre_parcent = @genre_price.to_f / @sum.to_f * 100.round(1)
    
    erb:newportfolio
end    


post '/makeportfolio' do
    # portfolio = Portfolio.create(
    #     user: session[:user],
    #     genre: @genre,
    #     total_price: @sum,
    #     genre_price: @sum,
    #     item_id: @id,
    #     post_id: @id
    # )
    p params[:color]
    p params[:selected_image1]
    p params[:selected_image2]

    # session[:portfolio_data] = portfolio
    # redirect "/portfolio/#{portfolio.id}"
    redirect '/portfolio/id'
end

get '/portfolio/id' do
    #@portfolio = session.delete(:portfolio_data) || Portfolio.find(params[:id])
    erb:portfoliodayo
end

get '/:id' do
    @items = Item.all
    @genre = @items.map{|item| item.genre}.uniq
    erb :mypage
end