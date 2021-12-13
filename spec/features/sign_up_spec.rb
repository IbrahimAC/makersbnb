feature "sign up" do
  scenario "user should be able to sign up" do
    visit('/')
    click_button('Sign up')
    fill_in("name", with: "Tomas")
    fill_in("email", with: "tomas_fake_email@gmail.com")
    fill_in("password", with: "password123")
    click_button("Sign up")
    expect(page).to have_content("Logged in as Tomas")
  end
end