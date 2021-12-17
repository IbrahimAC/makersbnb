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
                                                              'user_id' => 1,
                                                              'availability_from' => '2021-12-16',
                                                              'availability_until' => '2021-12-18'
                                                            }])
    @user = double('User', id: 1)
  end

  it 'creates a instance of space class' do
    res = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id, availability_from: "2022-01-01", availability_until: "2022-01-31")

    expect(res).to be_a Space
    expect(res.title).to eq 'House'
    expect(res.description).to eq 'My house'
    expect(res.picture).to eq 'url'
    expect(res.price).to eq '120'
    expect(res.user_id).to eq @user.id
  end

  it 'returns a list of all spaces' do
    space1 = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id, availability_from: "2022-01-01", availability_until: "2022-01-31")
    space2 = Space.create(title: 'Second House', description: 'My second house', picture: 'url', price: 130,
                          user_id: @user.id, availability_from: "2022-01-01", availability_until: "2022-01-31")

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
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id, availability_from: "2022-01-01", availability_until: "2022-01-31")
    found_space = Space.find(id: space.id)

    expect(found_space.id).to eq space.id
  end

  it "returns an array of available dates" do
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id, 
      availability_from: '2021-12-16', availability_until: '2021-12-18')
    
    result = Space.list_available_dates(space: space)
    expect(result.length).to eq 3
    expect(result).to be_a Array
    expect(result).to eq(['2021-12-16', '2021-12-17', '2021-12-18'])
  end

  it "deletes a space" do
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id, 
      availability_from: '2021-12-16', availability_until: '2021-12-18')
    expect(Space.all.length).to eq 1
  
    allow(DatabaseConnection).to receive(:query).and_call_original
    Space.delete(id: space.id)
    expect(Space.all.length).to eq 0
  end
  
  it 'should be able to update a booking' do
    allow(DatabaseConnection).to receive(:query).and_call_original
    DatabaseConnection.query("ALTER SEQUENCE spaces_id_seq RESTART WITH 1;")
    @user = User.create(name: 'Tomas', email: 'tomas_fake_email@gmail.com', password: 'password123')
    space = Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: @user.id, availability_from: "2022-01-01", availability_until: "2022-01-31")
    updated_space = Space.update(id: '1', title: 'Updated house', description: 'Updated description', picture: 'new_url', price: 150, availability_from: '2022-02-01', availability_until: '2022-02-21')
    expect(updated_space.title).to eq 'Updated house'
    expect(updated_space.description).to eq 'Updated description'
    expect(updated_space.picture).to eq 'new_url'
    expect(updated_space.price).to eq '150'
    expect(updated_space.user_id).to eq @user.id
    expect(updated_space.availability_from).to eq '2022-02-01'
    expect(updated_space.availability_until).to eq '2022-02-21'
  end

  # add find_by_user spec
end
