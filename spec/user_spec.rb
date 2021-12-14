# frozen_string_literal: true

require 'user'

describe User do
  it 'creates a new user' do
    user = User.create('Tomas', 'tomas_fake_email@gmail.com', 'password123')
    expect(user).to be_a_kind_of User
    expect(user.name).to eq 'Tomas'
    expect(user.email).to eq 'tomas_fake_email@gmail.com'
  end

  it 'user can be found by id' do
    DatabaseConnection.query('ALTER SEQUENCE users_id_seq RESTART WITH 1;')
    user = User.create('Tomas', 'tomas_fake_email@gmail.com', 'password123')
    found_user = User.find(1)
    expect(found_user.id).to eq user.id
    expect(found_user.name).to eq 'Tomas'
    expect(found_user.email).to eq 'tomas_fake_email@gmail.com'
  end

  it 'can check if an email already exists' do
    user = User.create('Tomas', 'tomas_fake_email@gmail.com', 'password123')
    expect(User.exists?('tomas_fake_email@gmail.com')).to be true
    expect(User.exists?('donaldtrump@gmail.com')).to be false
  end

  it 'should be able to authenticate log in' do
    user = User.create('Tomas', 'tomas_fake_email@gmail.com', 'password123')
    logged_in_user = User.authenticate('tomas_fake_email@gmail.com', 'password123')
    expect(logged_in_user.id).to eq user.id
    expect(logged_in_user.name).to eq 'Tomas'
    expect(logged_in_user.email).to eq 'tomas_fake_email@gmail.com'
  end

  it 'cannot log in with the wrong password' do
    user = User.create('Tomas', 'tomas_fake_email@gmail.com', 'password123')
    logged_in_user = User.authenticate('tomas_fake_email@gmail.com', 'fake')
    expect(logged_in_user).to be nil
  end
end
