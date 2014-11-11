require 'rails_helper'

feature "Sign Up" do

  before :each do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!",
    )

    visit root_path
    expect(page).to have_content("Sign In")
    click_on "Sign Up"
  end

  scenario "Sign up with valid data" do
    fill_in "First name", with: "Joe"
    fill_in "Last name", with: "Test"
    fill_in "Email", with: "joe@test.com"
    fill_in "Password", with: "1234$!"
    fill_in "Password confirmation", with: "1234$!"
    click_button "Sign Up"
    expect(page).to have_content("Joe Test")
    expect(page).to have_content("Sign Out")
  end

  scenario "Sign up with no email, no password" do
    click_button "Sign Up"
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

  scenario "Sign up with duplicate email, no password" do
    fill_in "Email", with: "joe@user.com"
    click_button "Sign Up"
    expect(page).to have_content("Email has already been taken")
    expect(page).to have_content("Password can't be blank")
  end

  scenario "Sign up without password confirmation" do
    fill_in "First name", with: "Joe"
    fill_in "Last name", with: "User"
    fill_in "Email", with: "joe@test.com"
    fill_in "Password", with: "1234$!"
    click_button "Sign Up"
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  scenario "Passwords don't match" do
    fill_in "First name", with: "Joe"
    fill_in "Last name", with: "User"
    fill_in "Email", with: "joe@test.com"
    fill_in "Password", with: "1234$!"
    fill_in "Password confirmation", with: "1234"
    click_button "Sign Up"
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
