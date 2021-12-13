# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'

# AirBnB class
class AirBnB < Sinatra::Base
  get '/' do
    'Welcome to Mango AirBnB '
  end

  run! if app_file == $PROGRAM_NAME
end
