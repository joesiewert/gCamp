require 'rails_helper'

feature "Memberships" do

  scenario "Add a membership" do
    project = create_project
    user1 = create_user
    user2 = create_user
    create_membership(project, user1)
    signin(user1)

    visit root_path
    click_on "Projects"
    find(".table").click_on(project.name)
    click_on "1 Member"
    within(".well") do
      select user2.full_name, from: "membership_user_id"
      select "Member", from: "membership_role"
    end
    click_on "Add New Member"
    expect(page).to have_content("#{user2.full_name} was added successfully.")
    within(".table") do
      expect(page).to have_link(user2.full_name)
      expect(page).to have_content("Member")
    end
    find(".breadcrumb").click_on(project.name)
    expect(page).to have_content("2 Members")
  end

  scenario "Update a membership" do
    project = create_project
    user = create_user
    membership = create_membership(project, user)
    signin(user)

    visit project_memberships_path(project)
    within(".table") do
      expect(page).to have_link(user.full_name)
      expect(page).to have_content(membership.role)
      select "Owner", from: "membership_role"
      click_on "Update"
    end
    expect(page).to have_content("#{user.full_name} was updated successfully.")
    within(".table") do
      expect(page).to have_link(user.full_name)
      expect(page).to have_content("Owner")
    end
    visit project_path(project)
    expect(page).to have_content("1 Member")
  end

  scenario "Remove a membership" do
    project = create_project
    user = create_user
    membership = create_membership(project, user)
    signin(user)

    visit project_memberships_path(project)
    within(".table") do
      expect(page).to have_link(user.full_name)
      expect(page).to have_content(membership.role)
      find(".glyphicon").click
    end
    #expect(page).to have_content("#{user.full_name} was removed successfully.")
    expect(Membership.count).to eq(0)
  end

  scenario "Must select a user" do
    project = create_project
    user = create_user
    create_membership(project, user)
    signin(user)

    visit project_memberships_path(project)
    click_on "Add New Member"
    expect(page).to have_content("User can't be blank")
    visit project_path(project)
    expect(page).to have_content("1 Member")
  end

  scenario "Can't add a duplicate user" do
    project = create_project
    user = create_user
    membership = create_membership(project, user)
    signin(user)

    visit project_memberships_path(project)
    within(".table") do
      expect(page).to have_link(user.full_name)
      expect(page).to have_content(membership.role)
    end
    within(".well") do
      select user.full_name, from: "membership_user_id"
      select "Owner", from: "membership_role"
      click_on "Add New Member"
    end
    expect(page).to have_content("User has already been added")
    visit project_path(project)
    expect(page).to have_content("1 Member")
  end

end
