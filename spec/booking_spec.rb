require 'booking'

describe Booking do
  it 'should be able to request a new booking' do
    user = User.create('Tomas', 'tomas_fake_email@gmail.com', 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)

    booking = Booking.request(user.id, space.id, '2022-01-08')
    expect(booking).to be_kind_of Booking
    expect(booking.user_id).to eq user.id
    expect(booking.space_id).to eq space.id
    expect(booking.date).to eq '2022-01-08'
    expect(booking.confirmed).to be_nil
  end

  it 'should be able to confirm a booking' do
    user = User.create('Tomas', 'tomas_fake_email@gmail.com', 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    booking = Booking.request(user.id, space.id, '2022-01-08')

    confirmed_booking = Booking.confirm(booking.id, true)
    expect(confirmed_booking.confirmed).to eq "t"
  end

  it 'should be able to reject a booking' do
    user = User.create('Tomas', 'tomas_fake_email@gmail.com', 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    booking = Booking.request(user.id, space.id, '2022-01-08')

    rejected_booking = Booking.confirm(booking.id, false)
    expect(rejected_booking.confirmed).to eq "f"
  end
end