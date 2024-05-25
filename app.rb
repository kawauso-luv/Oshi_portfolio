require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

get '/' do
    erb :index
end

get '/login' do
    erb :login
end

post '/signup' do
    user = User.create(name: params[:mail], password: params[:password], password_confirmation: params[:password_confirmation], name: params[:mail])
    if user.persisted?
        session[:user] = user.id
    end
    redirect '/mypage'
end

post '/signin' do
    user = User.find_by(mail: params[:mail])
    if user && user.autheniticate(params[:password])
        session[:user] = user.id
    end
  redirect '/mypage'
end