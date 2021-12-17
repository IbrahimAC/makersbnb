feature 'confirming booking' do
  scenario 'owner of space can confirm a booking request' do
    sign_up
    post_listing
    visit('/')
    click_on 'Log out'
    sign_up_user_2
    request_test_house
    log_in_user_1
    visit '/user/my_page'
    click_button 'Confirm'

    expect(page).to have_content "Confirmed"
    expect(page).to have_no_content "Not confirmed"
  end
end