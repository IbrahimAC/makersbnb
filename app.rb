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

  enable :sessions, :method_override
  register Sinatra::Flash

  before do
    @user = User.find(session[:id])
  end

  get '/' do
    erb :index, :layout => false
  end

  get '/user/new' do
    erb :'users/signup'
  end

  post '/user/signup' do
    user = User.create(name: params[:name], email: params[:email], password: params[:password])
    if user.nil?
      flash[:danger] = 'Email address in use. Please log in or sign up with a different email.'
      redirect '/user/new'
    else
      session[:id] = user.id
      flash[:success] = "Welcome to MakersBnB, #{user.name}"
      redirect '/spaces'
    end
  end

  get '/user/login' do
    erb :'users/login'
  end

  post '/user/logout' do
    session.clear
    flash[:success] = "You are now Logged out"
    redirect '/spaces'
  end

  post '/user/authenticate' do
    user = User.authenticate(params[:email], params[:password])
    if user.nil?
      flash[:danger] = 'Incorrect email or password.'
      redirect '/user/login'
    else
      flash[:success] = "Welcome back, #{user.name}"
      session[:id] = user.id
      redirect '/spaces'
    end
  end

  get '/user/bookings' do
    @spaces = Space.find_by_user(id: session[:id])
    @made_requests = Booking.made_requests(session[:id])
    @received_requests = Booking.received_requests(session[:id])
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
    space = Space.create(title: params[:title], description: params[:description], picture: params[:picture],
                           price: params[:price], user_id: session[:id], availability_from: params[:availability_from], availability_until: params[:availability_until]
    )
    flash[:success] = "Space created"
    redirect "/spaces/#{space.id}"
  end

  get '/spaces/:id' do
    @space = Space.find(id: params[:id])
    @space_owner = User.find(@space.user_id)
    erb :'/spaces/space'
  end


  delete '/spaces/delete/:id' do
    Space.delete(id: params[:id])
    flash[:success] = "Space deleted"
    redirect '/spaces'
  end

  get '/spaces/:id/update' do
    @space = Space.find(id: params[:id])
    @space_owner = User.find(@space.user_id)
    erb :'/spaces/update'
  end

  patch '/spaces/:id/update' do
    Space.update(id: params[:id], title: params[:title],
    description: params[:description], picture: params[:picture], price: params[:price],
    availability_from: params[:availability_from], availability_until: params[:availability_until])
    flash[:success] = "Space updated"
    redirect "/spaces/#{params[:id]}"
  end

  get '/bookings/:id/new' do
    @space_id = params[:id]
    @available_dates = Space.list_available_dates(space: Space.find(id: @space_id))
    @unavailable_dates = Booking.unavailable_dates(params[:id])
    erb :'bookings/new'
  end

  post '/bookings/:id' do
    Booking.request(session[:id], params[:id], params[:date])
    redirect 'user/bookings'
  end

  post '/bookings/:id/confirm' do
    Booking.confirm(params[:id], true)
    redirect 'user/bookings'
  end

  post '/bookings/:id/reject' do
    Booking.confirm(params[:id], false)
    redirect 'user/bookings'
  end

  run! if app_file == $PROGRAM_NAME
end
