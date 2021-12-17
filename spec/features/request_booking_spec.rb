# frozen_string_literal: true

feature 'requesting booking' do
  scenario 'user should be able to request booking' do
    sign_up
    post_listing
    visit('/')
    click_on 'Log out'
    sign_up_user_2
    request_test_house
    expect(page).to have_content 'Test house'
    expect(page).to have_content '2022-01-05'
  end
end
