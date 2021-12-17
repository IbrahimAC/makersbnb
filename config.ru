# frozen_string_literal: true
require './app'
require_relative 'controllers/booking_controller.rb'
require_relative 'controllers/spaces_controller.rb'
require_relative 'controllers/user_controller.rb'

Rack::MethodOverride
use BookingController
use SpacesController
use UsersController
run AirBnb
