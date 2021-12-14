feature 'log out' do
  scenario 'user should be able to log out' do
    sign_up
    click_button('Log out')
    expect(page).to have_button('Log in')
  end
end

feature 'log in' do
  scenario 'user should be able to log in' do
    sign_up
    click_button('Log out')
    click_button('Log in')
    fill_in("email", with: "tomas_fake_email@gmail.com")
    fill_in("password", with: "password123")
    click_button('Log in')
    expect(page).to have_current_path('/spaces')
  end
end