# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

# AirBnB class
class AirBnb < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end
  get '/' do
    'Welcome to Mango AirBnB'
  end

  run! if app_file == $PROGRAM_NAME
end
