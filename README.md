Setting up Makersbnb
-----
```
git clone https://github.com/IbrahimAC/makersbnb.git
cd makersbnb
bundle install
```

### Database configuration
```
1 - psql
2 - CREATE DATABASE makersbnb;
3 - CREATE DATABASE makersbnb_test;
4 - \c makersbnb
5 - Follow instructions in db/migrations
6 - repeat steps 4-5 for makersbnb_test
```

### Setting up email API 
```
Create data.env file with the following ENV vars:

SENDGRID_API=
EMAIL_FROM=

Optional (Sending email functionality)
----------------------------------------
Create [Sendgrid](https://app.sendgrid.com/) account
Add and verify a single sender email address
Add Sengrid API and verified email address to ENV vars in data.env
```

### Running the website
-----
```
rackup
visit 'localhost:9292'
```

# Database configuration
* CREATE DATABASE makersbnb;
* \c makersbnb
* CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(60), email VARCHAR(60), password VARCHAR);
* CREATE DATABASE makersbnb_test;
* \c makersbnb_test
* CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(60), email VARCHAR(60), password VARCHAR);


### Headline specifications

- Any signed-up user can list a new space.
- Users can list multiple spaces.
- Users should be able to name their space, provide a short description of the space, and a price per night.
- Users should be able to offer a range of dates where their space is available.
- Any signed-up user can request to hire any space for one night, and this should be approved by the user that owns that space.
- Nights for which a space has already been booked should not be available for users to book that space.
- Until a user has confirmed a booking request, that space can still be booked for that night.

### Nice-to-haves

- Users should receive an email whenever one of the following happens:
 - They sign up
 - They create a space
 - They update a space
 - A user requests to book their space
 - They confirm a request
 - They request to book a space
 - Their request to book a space is confirmed
 - Their request to book a space is denied
- Users should receive a text message to a provided number whenever one of the following happens:
 - A user requests to book their space
 - Their request to book a space is confirmed
 - Their request to book a space is denied
- A ‘chat’ functionality once a space has been booked, allowing users whose space-booking request has been confirmed to chat with the user that owns that space
- Basic payment implementation though Stripe.


