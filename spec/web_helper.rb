def sign_up
  visit('/')
  click_button('Sign up')
  fill_in("name", with: "Tomas")
  fill_in("email", with: "tomas_fake_email@gmail.com")
  fill_in("password", with: "password123")
  click_button("Sign up")
end