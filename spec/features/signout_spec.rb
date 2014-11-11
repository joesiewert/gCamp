require 'rails_helper'

feature "Sign Out" do

  scenario "Sign out" do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!",
    )

    visit root_path
    expect(page).to have_content("Sign Up")
    click_on "Sign In"
    fill_in "Email", with: "joe@user.com"
    fill_in "Password", with: "1234$!"
    click_button "Sign In"
    expect(page).to have_content("Joe User")
    click_on "Sign Out"
    expect(page).to have_content("Sign Up")
    expect(page).to have_content("Sign In")
    expect(page).to have_no_content("Joe User")
  end
end
