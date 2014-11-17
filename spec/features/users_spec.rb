require 'rails_helper'

feature "Users" do

  scenario "User creates a user" do
    visit root_path
    click_on "Users"
    expect(page).to have_no_content("Joe User")
    expect(page).to have_no_content("joe@user.com")
    click_on "Create User"
    fill_in "First name", with: "Joe"
    fill_in "Last name", with: "User"
    fill_in "Email", with: "joe@user.com"
    fill_in "Password", with: "1234$!"
    fill_in "Password confirmation", with: "1234$!"
    click_on "Create User"
    expect(page).to have_content("User was successfully created.")
    expect(page).to have_content("Joe User")
    expect(page).to have_content("joe@user.com")
  end

  scenario "User creates a user with invalid data" do
    visit root_path
    click_on "Users"
    click_on "Create User"
    click_on "Create User"
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

  scenario "User creates a user with duplicate email" do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!",
    )

    visit root_path
    click_on "Users"
    click_on "Create User"
    fill_in "Email", with: "joe@user.com"
    click_on "Create User"
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email has already been taken")
    expect(page).to have_content("Password can't be blank")
  end

  scenario "User views a user" do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!",
    )

    visit root_path
    click_on "Users"
    expect(page).to have_content("joe@user.com")
    click_on "Joe User"
    expect(page).to have_content("Joe User")
    expect(page).to have_content("Joe")
    expect(page).to have_content("User")
    expect(page).to have_content("joe@user.com")
  end

  scenario "User edits a user" do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!",
    )

    visit root_path
    click_on "Users"
    expect(page).to have_content("joe@user.com")
    click_on "Joe User"
    click_on "Edit"
    fill_in "First name", with: "Jojo"
    fill_in "Last name", with: "Tester"
    fill_in "Email", with: "jojo@tester.com"
    click_on "Update User"
    expect(page).to have_content("User was successfully updated.")
    expect(page).to have_content("Jojo Tester")
    expect(page).to have_content("jojo@tester.com")
    expect(page).to have_no_content("Joe User")
    expect(page).to have_no_content("joe@user.com")
  end

  scenario "User edits a user to have invalid data" do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!",
    )

    visit root_path
    click_on "Users"
    expect(page).to have_content("joe@user.com")
    click_on "Joe User"
    click_on "Edit"
    fill_in "First name", with: ""
    fill_in "Last name", with: ""
    fill_in "Email", with: ""
    click_on "Update User"
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email can't be blank")
  end

  scenario "User deletes a user" do
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!",
    )

    visit root_path
    click_on "Users"
    expect(page).to have_content("Joe User")
    expect(page).to have_content("joe@user.com")
    click_on "Edit"
    click_on "Delete User"
    expect(page).to have_content("User was successfully deleted.")
    expect(page).to have_no_content("Joe User")
    expect(page).to have_no_content("joe@user.com")
  end
end
