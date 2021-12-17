# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/reloader'
require './lib/user'
require './lib/space'
require './lib/booking'
require './lib/email'
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
      session[:id] = nil
      redirect '/user/new'
    else
      session[:id] = user.id
      Email.send_email(user_email: user.email,event: :sign_up)
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

  get '/user/my_page' do
    if @user
      @spaces = Space.find_by_user(id: session[:id])
      @made_requests = Booking.made_requests(session[:id])
      @received_requests = Booking.received_requests(session[:id])
      erb :'users/booking'
    else
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end

  delete '/users/delete/:id' do
    Space.delete(id: params[:id])
    flash[:success] = "Space deleted"
    redirect '/user/my_page'
  end

  get '/spaces' do
    @spaces = Space.all
    erb :'spaces/index'
  end

  get '/spaces/new' do
    if @user
      erb :'spaces/new'
    else
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end

  post '/spaces' do
    if Space.is_valid?(availability_from: params[:availability_from], availability_until: params[:availability_until])
      space = Space.create(title: params[:title], description: params[:description], picture: params[:picture],
                            price: params[:price], user_id: session[:id], availability_from: params[:availability_from], availability_until: params[:availability_until])
      Email.send_email(user_email: @user.email, event: :create_listing)
      flash[:success] = "Space created"
      redirect "/spaces/#{space.id}"
    else
      flash[:danger] = "End date must be after start date"
      redirect '/spaces/new'
    end
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
    if @user
      @space = Space.find(id: params[:id])
      @space_owner = User.find(@space.user_id)
      erb :'/spaces/update'
    else
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end

  patch '/spaces/:id/update' do
    Space.update(id: params[:id], title: params[:title],
    description: params[:description], picture: params[:picture], price: params[:price],
    availability_from: params[:availability_from], availability_until: params[:availability_until])
    flash[:success] = "Space updated"
    redirect "/spaces/#{params[:id]}"
  end

  get '/bookings/:id/new' do
    if @user
      @space_id = params[:id]
      @available_dates = Space.list_available_dates(space: Space.find(id: @space_id))
      @unavailable_dates = Booking.unavailable_dates(params[:id])
      erb :'bookings/new'
    else
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end

  post '/bookings/:id' do
    Booking.request(session[:id], params[:id], params[:date])
    redirect 'user/my_page'
  end

  post '/bookings/:id/confirm' do
    booking = Booking.confirm(params[:id], true)
    user = User.find(booking.user_id)
    Email.send_email(user_email: user.email, event: :booking_confirmed)
    Booking.confirm(params[:id], true)
    redirect 'user/my_page'
  end

  post '/bookings/:id/reject' do
    booking = Booking.confirm(params[:id], false)
    user = User.find(booking.user_id)
    Email.send_email(user_email: user.email, event: :booking_rejected)
    redirect 'user/my_page'
  end

run! if app_file == $PROGRAM_NAME
end
