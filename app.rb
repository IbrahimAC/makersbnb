# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require './lib/user'
require './lib/space'
require './database_connection_setup'
require 'sinatra/flash'

# AirBnB class
class AirBnb < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions
  register Sinatra::Flash

  get '/' do
    @user = User.find(session[:id])
    erb :index
  end

  get '/user/new' do
    erb :signup
  end

  post '/user/signup' do
    user = User.create(params[:name], params[:email], params[:password])
    if user.nil?
      flash[:error] = 'Email address in use. Please log in or sign up with a different email.'
      session[:id] = nil
    else
      session[:id] = user.id
    end
    redirect 'user/signup/confirmation'
  end

  get '/user/login' do
    erb :login
  end

  post '/user/logout' do
    session[:id] = nil
    redirect '/'
  end

  post '/user/authenticate' do
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      flash[:error] = 'Incorrect email or password.'
      session[:id] = nil
      redirect '/user/login'
    else
      session[:id] = user.id
      redirect '/spaces'
    end
  end

  get '/spaces' do
    @spaces = Space.all
    erb :'spaces/index'
  end

  get '/spaces/new' do
    erb :'spaces/new'
  end

  post '/spaces' do
    space = Space.create(title: params[:title], description: params[:description], picture: params[:picture], price: params[:price], user_id: session[:id])
    redirect "/spaces/#{space.id}"
  end

  get '/spaces/:id' do
    @space = Space.find(id: params[:id])
    @space_owner = User.find(@space.user_id)
    erb :'spaces/space'
  end

  get '/user/signup/confirmation' do
    @user = User.find(session[:id])
    erb :confirmation
  end

  run! if app_file == $PROGRAM_NAME
end
