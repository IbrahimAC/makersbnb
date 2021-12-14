# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require './lib/user'

# AirBnB class
class AirBnb < Sinatra::Base

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb :index
  end

  get '/user/new' do
    erb :signup
  end

  post 'user/signup' do
    user = User.create(params[:name], params[:email], params[:password])
    session[:id] = user.id
    redirect 'user/signup/confirmation'
  end

  get 'user/signup/confirmation' do
  end

  run! if app_file == $PROGRAM_NAME
end
