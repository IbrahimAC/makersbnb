# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require './lib/user'
require './lib/space'
require './lib/booking'
require './lib/email'
require './database_connection_setup'
require 'sinatra/flash'
require_relative './booking_controller.rb'
require_relative './spaces_controller.rb'
require_relative './user_controller.rb'

# AirBnB class
class AirBnb < Sinatra::Base
  use BookingController
  use SpacesController
  use UsersController

  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions, :method_override
  register Sinatra::Flash

  before do
    @user = User.find(session[:id])
  end

  get '/' do
    erb :'index', :layout => false
  end

run! if app_file == $PROGRAM_NAME
end
