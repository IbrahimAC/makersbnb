# frozen_string_literal: true

def sign_up
  visit('/spaces')
  click_on('Sign up')
  fill_in('name', with: 'Tomas')
  fill_in('email', with: 'tomas_fake_email@gmail.com')
  fill_in('password', with: 'password123')
  click_button('Submit')
end

def sign_up_user_2
  visit('/')
  click_on('Sign up')
  fill_in('name', with: 'Kim')
  fill_in('email', with: 'kim_fake_email@gmail.com')
  fill_in('password', with: 'password123')
  click_button('Submit')
end

def log_in_user_1
  click_on 'Log out'
  click_on 'Log in'
  fill_in('email', with: 'tomas_fake_email@gmail.com')
  fill_in('password', with: 'password123')
  click_button('Submit')
end

def post_listing
  visit '/spaces/new'
  fill_in 'title', with: 'Test house'
  fill_in 'description', with: 'house description'
  fill_in 'price', with: '25'
  fill_in 'picture', with: 'url'
  fill_in "availability_from", with: "2022/01/01"
  fill_in "availability_until", with: "2022/01/31"
  click_button 'Create space'
end

def request_test_house
  visit('/spaces')
  click_link('Test house')
  click_link('Request booking')
  select('2022-01-05', from: 'date')
  click_on('Make request')
end
