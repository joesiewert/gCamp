require 'rails_helper'

feature "Sign In" do

  before :each do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!",
    )

    visit root_path
    expect(page).to have_content("Sign Up")
    click_on "Sign In"
  end

  scenario "Sign in with valid data" do
    fill_in "Email", with: "joe@user.com"
    fill_in "Password", with: "1234$!"
    click_button "Sign In"
    expect(page).to have_content("Joe User")
    expect(page).to have_content("Sign Out")
  end

  scenario "Sign in with no email, no password" do
    click_button "Sign In"
    expect(page).to have_content("Username / password combination is invalid")
  end

  scenario "Sign in with email, no password" do
    fill_in "Email", with: "joe@user.com"
    click_button "Sign In"
    expect(page).to have_content("Username / password combination is invalid")
  end

  scenario "Sign in with password, no email" do
    fill_in "Password", with: "1234$!"
    click_button "Sign In"
    expect(page).to have_content("Username / password combination is invalid")
  end

  scenario "Sign in with invalid email and password" do
    fill_in "Email", with: "fakeuser@test.com"
    fill_in "Password", with: "1234"
    click_button "Sign In"
    expect(page).to have_content("Username / password combination is invalid")
  end
end
