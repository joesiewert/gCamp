require 'rails_helper'

feature "Projects" do

  scenario "User creates a project" do
    visit root_path
    click_on "Projects"
    expect(page).to have_no_content("Amazeo 1.1")
    click_on "Create Project"
    fill_in "Name", with: "Amazeo 1.1"
    click_on "Create Project"
    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Amazeo 1.1")
    within(".breadcrumb") do
      click_on "Projects"
    end
    expect(page).to have_content("Amazeo 1.1")
  end

  scenario "User creates a project without a name" do
    visit root_path
    click_on "Projects"
    click_on "Create Project"
    click_on "Create Project"
    expect(page).to have_content("Create project")
    expect(page).to have_content("Name can't be blank")
  end

  scenario "User views a project" do
    Project.create!(
      name: "Amazeo 1.1"
    )

    visit root_path
    click_on "Projects"
    click_on "Amazeo 1.1"
    expect(page).to have_content("Amazeo 1.1")
  end

  scenario "User edits a project" do
    Project.create!(
      name: "Amazeo 1.1"
    )

    visit root_path
    click_on "Projects"
    click_on "Amazeo 1.1"
    click_on "Edit"
    fill_in "Name", with: "Amazeo 1.2"
    click_on "Update Project"
    expect(page).to have_content("Project was successfully updated.")
    expect(page).to have_content("Amazeo 1.2")
    expect(page).to have_no_content("Amazeo 1.1")
    within(".breadcrumb") do
      click_on "Projects"
    end
    expect(page).to have_content("Amazeo 1.2")
    expect(page).to have_no_content("Amazeo 1.1")
  end

  scenario "User edits a project to have no name" do
    Project.create!(
      name: "Amazeo 1.1"
    )

    visit root_path
    click_on "Projects"
    click_on "Amazeo 1.1"
    click_on "Edit"
    fill_in "Name", with: ""
    click_on "Update Project"
    expect(page).to have_content("Edit project")
    expect(page).to have_content("Name can't be blank")
    click_on "Projects"
    expect(page).to have_content("Amazeo 1.1")
  end

  scenario "User deletes a project" do
    Project.create!(
      name: "Amazeo 1.1"
    )

    visit root_path
    click_on "Projects"
    click_on "Amazeo 1.1"
    click_on "Destroy"
    expect(page).to have_content("Project was successfully destroyed.")
    expect(page).to have_no_content("Amazeo 1.1")
  end
end
