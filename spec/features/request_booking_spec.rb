# frozen_string_literal: true

feature 'requesting booking' do
  scenario 'user should be able to request booking' do
    sign_up
    visit '/spaces/new'
    fill_in 'title', with: 'Test house'
    fill_in 'description', with: 'house description'
    fill_in 'price', with: '25'
    fill_in 'picture', with: 'url'
    click_button 'Create space'
    visit('/')
    click_button 'Log out'
    visit('/')
    click_button('Sign up')
    fill_in('name', with: 'Kim')
    fill_in('email', with: 'kim_fake_email@gmail.com')
    fill_in('password', with: 'password123')
    click_button('Submit')
    visit('/spaces')
    click_link('Test house')
    click_button('Request booking')
    fill_in('date', with: '2022-01-05')
    click_button('Make request')
    expect(page).to have_content 'Request made'
  end
end
