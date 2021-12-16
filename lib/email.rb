require 'sendgrid-ruby'
require 'dotenv'
Dotenv.load('data.env')
include SendGrid

class Email
  # ENV VAR FOR SEND EMAIL

  def self.send_email(from: ENV['EMAIL_FROM'], user_email:,event:)
  from = SendGrid::Email.new(email: "#{from}")

    # TAKE FROM USER.email
    to = SendGrid::Email.new(email: "#{user_email}")
    subject = "MakersBnB"
    content = SendGrid::Content.new(type: 'text/plain', value: "#{Email.content(event: event)}")
    mail = SendGrid::Mail.new(from, subject, to, content)

    ##### REMOVE API --> ENV VAR
    sg = SendGrid::API.new(api_key:"#{ENV['SENDGRID_API']}")
    response = sg.client.mail._('send').post(request_body: mail.to_json)
  end

  def self.content(event:)
    events = {
      sign_up: "You're account has been created",
      create_listing: "You've listed a space",
      booking_confirmed: "Your booking request has been confirmed",
      booking_rejected: "Your booking request has been rejected",
      request_received: "There is a new request for your property"
    }
    events[event]
  end
end
