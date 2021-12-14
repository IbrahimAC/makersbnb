# frozen_string_literal: true

require 'space'
require 'user'

describe 'Space' do
  it 'creates a instance of space class' do
    # allow(DatabaseConnection).to receive(:query).and_return("INSERT INTO users (name,email,password) VALUES($1,$2,$3)
    # RETURNING id, name, email, password;",
    # ["test","email","password"])

    user = User.create('Test', 'test@example.com', 'password')
    res = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)

    expect(res).to be_a Space
    expect(res.title).to eq 'House'
    expect(res.description).to eq 'My house'
    expect(res.picture).to eq 'url'
    expect(res.price).to eq '120'
    expect(res.user_id).to eq user.id
  end

  it 'returns a list of all spaces' do
    user = User.create('Test', 'test@example.com', 'password')
    space1 = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: user.id)
    space2 = Space.create(title: 'Second House', description: 'My second house', picture: 'url', price: 130,
                          user_id: user.id)

    res = Space.all
    expect(res.length).to eq 2
    expect(res[0].id).to eq space1.id
    expect(res[1].id).to eq space2.id
  end
end
