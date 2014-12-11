require 'rails_helper'

feature "Users" do

  scenario "User creates a user" do
    user = create_user
    signin(user)

    visit root_path
    visit users_path
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
    user = create_user
    signin(user)

    visit users_path
    click_on "Create User"
    click_on "Create User"
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

  scenario "User creates a user with duplicate email" do
    user = create_user
    signin(user)

    visit users_path
    click_on "Create User"
    fill_in "Email", with: user.email
    click_on "Create User"
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Email has already been taken")
    expect(page).to have_content("Password can't be blank")
  end

  scenario "User views a user" do
    user = create_user
    signin(user)

    visit users_path
    expect(page).to have_content(user.email)
    find(".table").click_on(user.full_name)
    expect(page).to have_content(user.full_name)
    expect(page).to have_content(user.first_name)
    expect(page).to have_content(user.last_name)
    expect(page).to have_content(user.email)
  end

  scenario "User edits a user" do
    user = create_user
    signin(user)
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!"
    )

    visit users_path
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
    user = create_user
    signin(user)
    User.create!(
      first_name: "Joe",
      last_name: "User",
      email: "joe@user.com",
      password: "1234$!"
    )

    visit users_path
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
    user = create_user
    signin(user)

    visit users_path
    expect(page).to have_content(user.full_name)
    expect(page).to have_content(user.email)
    click_on "Edit"
    click_on "Delete User"
    #expect(page).to have_content("User was successfully deleted.")
    #expect(page).to have_no_content(user.full_name)
    #expect(page).to have_no_content(user.email)
    expect(User.count).to eq(0)
  end

  scenario "User deletes a user with existing membership and comments" do
    user1 = create_user
    project = create_project
    create_membership(project, user1)
    task = create_task(project)

    3.times do
      create_comment(task, user1)
    end

    signin(user1)
    expect(User.count).to eq(1)
    expect(Membership.count).to eq(1)
    expect(Comment.count).to eq(3)
    visit users_path
    click_on "Edit"
    click_on "Delete User"
    expect(User.count).to eq(0)
    expect(Membership.count).to eq(0)
    user2 = create_user
    create_membership(project, user2)
    signin(user2)
    visit project_tasks_path(project)
    within(".badge") do
      expect(page).to have_content("3")
    end
    click_on task.description
    expect(page).to have_content("Deleted User")
  end

end
