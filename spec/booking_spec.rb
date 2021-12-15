require 'booking'

describe Booking do
  it 'should be able to request a new booking' do
    user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)

    booking = Booking.request(user.id, space.id, '2022-01-08')
    expect(booking).to be_kind_of Booking
    expect(booking.user_id).to eq user.id
    expect(booking.space_id).to eq space.id
    expect(booking.date).to eq '2022-01-08'
    expect(booking.confirmed).to be_nil
  end

  it 'should not be able to request a booking if already booked' do
    user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    booking = Booking.request(user.id, space.id, '2022-01-08')
    Booking.confirm(booking.id, true)
    double_booking = Booking.request(user.id, space.id, '2022-01-08')
    expect(double_booking).to be nil
  end

  it 'should be able to confirm a booking' do
    user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    booking = Booking.request(user.id, space.id, '2022-01-08')

    confirmed_booking = Booking.confirm(booking.id, true)
    expect(confirmed_booking.confirmed).to eq "t"
  end

  it 'should be able to reject a booking' do
    user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    booking = Booking.request(user.id, space.id, '2022-01-08')

    rejected_booking = Booking.confirm(booking.id, false)
    expect(rejected_booking.confirmed).to eq "f"
  end

  it 'should be able to check if a space has already been booked for a date' do
    user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    booking = Booking.request(user.id, space.id, '2022-01-08')
    Booking.confirm(booking.id, true)
    expect(Booking.already_booked?(space.id, '2022-01-08')).to be true
  end

  it 'should be able to show all the unavailable dates of a space' do
    user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    booking = Booking.request(user.id, space.id, '2022-01-08')
    Booking.confirm(booking.id, true)
    booking_2 = Booking.request(user.id, space.id, '2022-01-11')
    Booking.confirm(booking_2.id, true)
    booking_3 = Booking.request(user.id, space.id, '2022-01-15')
    Booking.confirm(booking_3.id, true)
    expect(Booking.unavailable_dates(space.id)).to match_array (['2022-01-08', '2022-01-11', '2022-01-15'])
  end

  it 'should show all the requests a user has received' do
    user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    booking = Booking.request(user.id, space.id, '2022-01-08')
    booking_2 = Booking.request(user.id, space.id, '2022-01-10')
    expect(Booking.received_requests(user.id)[0].id). to eq booking.id
    expect(Booking.received_requests(user.id)[0].user_id). to eq booking.user_id
    expect(Booking.received_requests(user.id)[0].space_id). to eq booking.space_id
    expect(Booking.received_requests(user.id)[0].date). to eq '2022-01-08'
    expect(Booking.received_requests(user.id)[0].confirmed). to be nil
    expect(Booking.received_requests(user.id)[1].date). to eq '2022-01-10'
  end

end