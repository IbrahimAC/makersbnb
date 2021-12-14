require 'space'
require 'user'

describe "Space" do
  it "creates a instance of space class" do
    # allow(DatabaseConnection).to receive(:query).and_return("INSERT INTO users (name,email,password) VALUES($1,$2,$3) 
    # RETURNING id, name, email, password;", 
    # ["test","email","password"])

    user = User.create(name: "Test", email: "test@example.com", password: "password")
    res = Space.create(title: "House", description: "My house", picture: "url", price: 120, user_id: user.id)
    
    expect(res).to be_a Space
    expect(res.title).to eq "House"
    expect(res.description).to  eq "My house"
    expect(res.picture).to  eq "url"
    expect(res.price).to  eq "120"
    expect(res.user_id).to eq user.id
  end

end