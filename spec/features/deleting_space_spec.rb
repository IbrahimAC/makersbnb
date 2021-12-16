feature "user can delete a space" do
  
  scenario "when we click delete button space is no longer visibile" do
    sign_up
    visit '/spaces/new'
    fill_in 'title', with: 'Test house'
    fill_in 'description', with: 'house description'
    fill_in 'price', with: '25'
    fill_in 'picture', with: 'url'
    fill_in 'availability_from', with: '2022-01-15'
    fill_in 'availability_until', with: '2022-01-18'
    click_button 'Create space'

    expect(page).to have_content 'Test house'
    click_button 'Delete'
    expect(page).to have_content 'Space deleted'
    expect(page).to_not have_content 'Test house'
  end

end