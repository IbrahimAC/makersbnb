
class BookingController < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  before '/bookings/*' do
    if @user == nil
      flash[:danger] = "Must be logged in to do that. Please log in or #{'<a href="/user/new">sign up</a>'}."
      redirect '/user/login'
    end
  end

  get '/bookings/:id/new' do
      @space_id = params[:id]
      @available_dates = Space.list_available_dates(space: Space.find(id: @space_id))
      @unavailable_dates = Booking.unavailable_dates(params[:id])
      erb :'bookings/new'
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
end