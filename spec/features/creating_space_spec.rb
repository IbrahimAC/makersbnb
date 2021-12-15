# frozen_string_literal: true

feature 'Create' do
  scenario 'a user can create a space' do
    sign_up
    visit '/spaces/new'
    fill_in 'title', with: 'Test house'
    fill_in 'description', with: 'house description'
    fill_in 'price', with: '25'
    fill_in 'picture', with: 'url'
    click_button 'Create space'

    expect(page).to have_content 'Test house'
    expect(page).to have_content 'house description'
    expect(page).to have_content '£25'
  end
end
