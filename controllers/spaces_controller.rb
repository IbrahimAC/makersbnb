
class SpacesController < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

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
    if @user
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
    else
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end

  get '/spaces/:id' do
    @space = Space.find(id: params[:id])
    @space_owner = User.find(@space.user_id)
    erb :'/spaces/space'
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
    if @user
      Space.update(id: params[:id], title: params[:title],
      description: params[:description], picture: params[:picture], price: params[:price],
      availability_from: params[:availability_from], availability_until: params[:availability_until])
      flash[:success] = "Space updated"
      redirect "/spaces/#{params[:id]}"
    else
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end
end