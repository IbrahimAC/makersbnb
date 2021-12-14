# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/space.rb'
require_relative './database_connection_setup.rb'

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
    @spaces = Space.all
    erb :spaces
  end

  run! if app_file == $PROGRAM_NAME
end
