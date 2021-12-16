feature 'reject booking' do
  scenario 'owner of space can reject a booking request' do
    sign_up
    post_listing
    visit('/')
    # click_button 'Log out'
    # visit('/')
    # click_button('Sign up')
    # fill_in('name', with: 'Kim')
    # fill_in('email', with: 'kim_fake_email@gmail.com')
    # fill_in('password', with: 'password123')
    # click_button('Submit')
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
    click_button 'Reject'

    expect(page).to have_content "Rejected"
    expect(page).to have_no_content "Not confirmed"
    expect(page).to have_no_content "Confirmed"
  end
end