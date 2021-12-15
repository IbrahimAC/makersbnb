# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require './lib/user'
require './lib/space'
require './lib/booking'
require './database_connection_setup'
require 'sinatra/flash'

# AirBnB class
class AirBnb < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  enable :sessions
  register Sinatra::Flash

  before do
    @user = User.find(session[:id])
  end

  get '/' do
    erb :index
  end

  get '/user/new' do
    erb :'users/signup'
  end

  post '/user/signup' do
    user = User.create(name: params[:name], email: params[:email], password: params[:password])
    if user.nil?
      flash[:error] = 'Email address in use. Please log in or sign up with a different email.'
      session[:id] = nil
    else
      session[:id] = user.id
    end
    redirect 'user/signup/confirmation'
  end

  get '/user/signup/confirmation' do
    erb :'users/confirmation'
  end

  get '/user/login' do
    erb :'users/login'
  end

  post '/user/logout' do
    session.clear
    redirect '/'
  end

  post '/user/authenticate' do
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      flash[:error] = 'Incorrect email or password.'
      redirect '/user/login'
    else
      session[:id] = user.id
      redirect '/spaces'
    end
  end

  get '/user/bookings' do
    erb :'users/booking'
  end

  get '/spaces' do
    @spaces = Space.all
    erb :'spaces/index'
  end

  get '/spaces/new' do
    erb :'spaces/new'
  end

  post '/spaces' do
    p availability_from: session[:availability_from]
    p space = Space.create(title: params[:title], description: params[:description], picture: params[:picture],
                           price: params[:price], user_id: session[:id], availability_from: params[:availability_from], availability_until: params[:availability_until])
    redirect "/spaces/#{space.id}"
  end

  get '/spaces/:id' do
    @space = Space.find(id: params[:id])
    @space_owner = User.find(@space.user_id)
    erb :'/spaces/space'
  end

  get '/user/signup/confirmation' do
    erb :'users/confirmation'
  end

  get '/bookings/:id/new' do
    @space_id = params[:id]
    @available_dates = %w[2022-01-01 2022-01-02 2022-01-03 2022-01-04 2022-01-05 2022-01-06]
    # @unavailable_dates = Booking.unavailable_dates(params[:id])
    @unavailable_dates = ['2022-01-02']
    erb :'bookings/new'
  end

  post '/bookings/:id' do
    Booking.request(session[:id], params[:id], params[:date])
    redirect 'user/bookings'
  end

  run! if app_file == $PROGRAM_NAME
end
