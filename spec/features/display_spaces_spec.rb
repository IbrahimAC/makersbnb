# frozen_string_literal: true

feature 'displays a list of spaces' do
  scenario 'spaces get shown to user' do
    res = User.create(name: 'Test', email: 'test@example.com', password: 'password')
    Space.create(title: 'House', description: 'My house', picture: 'url', price: 120, user_id: res.id, availability_from: "2022-01-01", availability_until: "2022-01-31")
    visit('/spaces')

    expect(page).to have_content('House')
    expect(page).to have_content('120')
  end
end
