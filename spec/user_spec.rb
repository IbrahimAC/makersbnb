# frozen_string_literal: true

require 'user'

describe User do
  before do
    allow(DatabaseConnection).to receive(:query).and_return([{
                                                              'id' => '1',
                                                              'name' => 'Tomas',
                                                              'email' => 'tomas_fake_email@gmail.com',
                                                              'password' => BCrypt::Password.create('password123')
                                                            }])
    @user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
  end

  it 'creates a new user' do
    expect(@user).to be_a_kind_of User
    expect(@user.name).to eq 'Tomas'
    expect(@user.email).to eq 'tomas_fake_email@gmail.com'
  end

  it 'user can be found by id' do
    found_user = User.find(@user.id)
    expect(found_user.id).to eq @user.id
    expect(found_user.name).to eq 'Tomas'
    expect(found_user.email).to eq 'tomas_fake_email@gmail.com'
  end

  it 'can check if an email already exists' do
    allow(DatabaseConnection).to receive(:query).and_return([{ 'exists' => 't' }])
    expect(User.exists?('tomas_fake_email@gmail.com')).to be true

    allow(DatabaseConnection).to receive(:query).and_return([{ 'exists' => 'f' }])
    expect(User.exists?('donaldtrump@gmail.com')).to be false
  end

  it 'should be able to authenticate log in' do
    allow(DatabaseConnection).to receive(:query).and_return([{ 'exists' => 't' }], [{
                                                              'id' => '1',
                                                              'name' => 'Tomas',
                                                              'email' => 'tomas_fake_email@gmail.com',
                                                              'password' => BCrypt::Password.create('password123')
                                                            }])

    logged_in_user = User.authenticate('tomas_fake_email@gmail.com', 'password123')
    expect(logged_in_user.id).to eq @user.id
    expect(logged_in_user.name).to eq 'Tomas'
    expect(logged_in_user.email).to eq 'tomas_fake_email@gmail.com'
  end

  it 'cannot log in with the wrong password' do
    user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')

    allow(DatabaseConnection).to receive(:query).and_return([{ 'exists' => 'f' }])
    logged_in_user = User.authenticate('tomas_fake_email@gmail.com', 'fake')
    expect(logged_in_user).to be nil
  end
end
