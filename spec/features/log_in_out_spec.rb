# frozen_string_literal: true

feature 'log out' do
  scenario 'user should be able to log out' do
    sign_up
    click_on('Log out')
    expect(page).to have_link('Log in')
  end
end

feature 'log in' do
  scenario 'user should be able to log in' do
    sign_up
    click_on('Log out')
    click_on('Log in')
    fill_in('email', with: 'tomas_fake_email@gmail.com')
    fill_in('password', with: 'password123')
    click_button('Submit')
    expect(page).to have_current_path('/spaces')
  end
end
