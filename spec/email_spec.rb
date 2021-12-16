require 'email'
require 'dotenv'
Dotenv.load('data.env')

describe Email do
  
  it "It sends an email" do
    stub_request(:post, "https://api.sendgrid.com/v3/mail/send").
    with(
      body: "{\"from\":{\"email\":\"makers@example.com\"},\"subject\":\"MakersBnB\",\"personalizations\":[{\"to\":[{\"email\":\"test@example.com\"}]}],\"content\":[{\"type\":\"text/plain\",\"value\":\"Your account has been created\"}]}",
      headers: {
     'Accept'=>'application/json',
     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     'Authorization'=>"Bearer #{ENV['SENDGRID_API']}",
     'Content-Type'=>'application/json',
     'User-Agent'=>'sendgrid/6.6.0;ruby'
      }).
    to_return(status: 200, body: "", headers: {})
    Email.send_email(from: 'makers@example.com', user_email: 'test@example.com',event: :sign_up)
  end

  context "returns email content" do
    it "returns a signup message" do
      res = Email.content(event: :sign_up)
      expect(res).to eq "Your account has been created"
    end

    it "returns a signup message" do
      res = Email.content(event: :create_listing)
      expect(res).to eq "You've listed a space"
    end
    
    it "returns a signup message" do
      res = Email.content(event: :booking_confirmed)
      expect(res).to eq "Your booking request has been confirmed"
    end

    it "returns a signup message" do
      res = Email.content(event: :booking_rejected)
      expect(res).to eq "Your booking request has been rejected"
    end

    it "returns a signup message" do
      res = Email.content(event: :request_received)
      expect(res).to eq "There is a new request for your property"
    end
  end

end
