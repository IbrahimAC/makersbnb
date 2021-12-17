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
    log_in_user_1
    expect(page).to have_current_path('/spaces')
  end
end
