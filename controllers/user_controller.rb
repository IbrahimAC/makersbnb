
class UsersController < Sinatra::Base
  enable :sessions,:method_override
  register Sinatra::Flash

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
      erb :'users/my_page'
    else
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end

  delete '/users/delete/:id' do
    if @user
      Space.delete(id: params[:id])
      flash[:success] = "Space deleted"
      redirect '/user/my_page'
    else
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end
end