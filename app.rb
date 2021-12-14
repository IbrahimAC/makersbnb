# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

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
    redirect '/spaces'
  end

  get '/spaces' do
    erb :spaces
  end

  run! if app_file == $PROGRAM_NAME
end
