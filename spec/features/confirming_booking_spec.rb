feature 'confirming booking' do
  scenario 'owner of space can confirm a booking request' do
    sign_up
    visit '/spaces/new'
    fill_in 'title', with: 'Test house'
    fill_in 'description', with: 'house description'
    fill_in 'price', with: '25'
    fill_in 'picture', with: 'url'
    fill_in "availability_from", with: "2022/01/01"
    fill_in "availability_until", with: "2022/01/31"
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
    click_link('Request booking')
    select('2022-01-05', from: 'date')
    click_on('Make request')

    click_button 'Log out'
    click_button 'Log in'
    fill_in('email', with: 'tomas_fake_email@gmail.com')
    fill_in('password', with: 'password123')
    click_button('Submit')

    visit 'user/bookings'
    click_button 'Confirm'

    expect(page).to have_content "Confirmed"
    expect(page).to have_no_content "Not confirmed"
  end
end