require 'rails_helper'

feature "Memberships" do

  scenario "Add a membership" do
    project = create_project
    user = create_user

    visit root_path
    click_on "Projects"
    click_on project.name
    click_on "0 Members"
    select user.full_name, from: "membership_user_id"
    select "Member", from: "membership_role"
    click_on "Add New Member"
    expect(page).to have_content("#{user.full_name} was added successfully.")
    within(".table") do
      expect(page).to have_selector(:link_or_button, user.full_name)
      expect(page).to have_content("Member")
    end
    find(".breadcrumb").click_on(project.name)
    expect(page).to have_content("1 Member")
  end

  scenario "Update a membership" do
    project = create_project
    user = create_user
    membership = create_membership(project, user)

    visit project_memberships_path(project)
    within(".table") do
      expect(page).to have_selector(:link_or_button, user.full_name)
      expect(page).to have_content(membership.role)
      select "Owner", from: "membership_role"
      click_on "Update"
    end
    expect(page).to have_content("#{user.full_name} was updated successfully.")
    within(".table") do
      expect(page).to have_selector(:link_or_button, user.full_name)
      expect(page).to have_content("Owner")
    end
    visit project_path(project)
    expect(page).to have_content("1 Member")
  end

  scenario "Remove a membership" do
    project = create_project
    user = create_user
    membership = create_membership(project, user)

    visit project_memberships_path(project)
    within(".table") do
      expect(page).to have_selector(:link_or_button, user.full_name)
      expect(page).to have_content(membership.role)
      find(".glyphicon").click
    end
    expect(page).to have_content("#{user.full_name} was removed successfully.")
    within(".table") do
      expect(page).to have_no_selector(:link_or_button, user.full_name)
      expect(page).to have_no_content(membership.role)
    end
    visit project_path(project)
    expect(page).to have_content("0 Members")
  end

  scenario "Must select a user" do
    project = create_project

    visit project_memberships_path(project)
    click_on "Add New Member"
    expect(page).to have_content("User can't be blank")
    visit project_path(project)
    expect(page).to have_content("0 Members")
  end

  scenario "Can't add a duplicate user" do
    project = create_project
    user = create_user
    membership = create_membership(project, user)

    visit project_memberships_path(project)
    within(".table") do
      expect(page).to have_selector(:link_or_button, user.full_name)
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
