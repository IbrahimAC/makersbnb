feature "user can delete a space" do
  
  scenario "when we click delete button space is no longer visibile" do
    sign_up
    post_listing
    visit '/user/my_page'
    expect(page).to have_content 'Test house'
    click_button 'Delete'
    expect(page).to have_content 'Space deleted'
    expect(page).to_not have_content 'Test house'
  end

end