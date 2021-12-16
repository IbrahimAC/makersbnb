# frozen_string_literal: true

feature 'sign up' do
  scenario 'user should be able to sign up' do
    sign_up
    expect(page).to have_content('Welcome to MakersBnB, Tomas')
  end

  scenario 'user cannot sign up with existing email' do
    sign_up
    click_on('Log out')
    sign_up
    expect(page).to have_content('Email address in use. Please log in or sign up with a different email.')
  end
end
