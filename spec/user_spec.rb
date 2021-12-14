require 'user'

describe User do

  it "creates a new user" do
    user = User.create(name: "Tomas", email: "tomas_fake_email@gmail.com", password: "password123")
    expect(user).to be_a_kind_of User
    expect(user.name).to eq "Tomas"
    expect(user.email).to eq "tomas_fake_email@gmail.com"
  end

end