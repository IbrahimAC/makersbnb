feature 'update booking' do
  scenario 'a user should be able to update their booking' do
    sign_up
    post_listing
    visit '/user/bookings'
    click_link('Update')
    fill_in 'title', with: 'Updated house'
    fill_in 'description', with: 'updated house description'
    fill_in 'price', with: '30'
    fill_in 'picture', with: 'new_url'
    fill_in "availability_from", with: "2022/02/01"
    fill_in "availability_until", with: "2022/02/20"
    click_button('Update')
    expect(page).to have_content 'Updated house'
    expect(page).to have_no_content 'Test house'
    expect(page).to have_content 'updated house description'
    expect(page).to have_content '30'
    expect(page).to have_no_content '25'
  end
end