# frozen_string_literal: true

require 'space'
require 'user'

describe 'Space' do
  before do
    allow(DatabaseConnection).to receive(:query).and_return([{
                                                              'id' => '1',
                                                              'title' => 'House',
                                                              'description' => 'My house',
                                                              'picture' => 'url',
                                                              'price' => '120',
                                                              'user_id' => 1
                                                            }])
    @user = double('User', id: 1)
  end

  it 'creates a instance of space class' do
    res = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id)

    expect(res).to be_a Space
    expect(res.title).to eq 'House'
    expect(res.description).to eq 'My house'
    expect(res.picture).to eq 'url'
    expect(res.price).to eq '120'
    expect(res.user_id).to eq @user.id
  end

  it 'returns a list of all spaces' do
    space1 = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id)
    space2 = Space.create(title: 'Second House', description: 'My second house', picture: 'url', price: 130,
                          user_id: @user.id)

    allow(DatabaseConnection).to receive(:query).and_return([
                                                              { 'id' => '1',
                                                                'title' => 'House',
                                                                'description' => 'My house',
                                                                'picture' => 'url',
                                                                'price' => '120',
                                                                'user_id' => 1 },

                                                              { 'id' => '2',
                                                                'title' => 'Second House',
                                                                'description' => 'My second house',
                                                                'picture' => 'url',
                                                                'price' => '130',
                                                                'user_id' => 1 }
                                                            ])

    res = Space.all

    expect(res.length).to eq 2
    expect(res[0]).to be_a Space
    expect(res[0].title).to eq 'House'
    expect(res[1]).to be_a Space
    expect(res[1].title).to eq 'Second House'
  end

  it 'find a space by id' do
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id)
    found_space = Space.find(id: space.id)

    expect(found_space.id).to eq space.id
  end
end
