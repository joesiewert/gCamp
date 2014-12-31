require 'rails_helper'

feature "Projects" do

  scenario "User creates a project" do
    user = create_user
    signin(user)

    visit root_path
    click_on "My Projects"
    expect(page).to have_no_content("Amazeo 1.1")
    click_on "Create Project"
    fill_in "Name", with: "Amazeo 1.1"
    click_on "Create Project"
    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Tasks for Amazeo 1.1")
    within(".breadcrumb") do
      click_on "Amazeo 1.1"
    end
    click_on "1 Member"
    within(".table") do
      expect(page).to have_link(user.full_name)
      expect(page).to have_content("Owner")
    end
    within(".breadcrumb") do
      click_on "Projects"
    end
    expect(page).to have_content("Amazeo 1.1")
  end

  scenario "User creates a project without a name" do
    user = create_user
    signin(user)

    visit root_path
    click_on "My Projects"
    click_on "Create Project"
    click_on "Create Project"
    expect(page).to have_content("Create project")
    expect(page).to have_content("Name can't be blank")
  end

  scenario "User views a project" do
    project = Project.create!(
      name: "Amazeo 1.1"
    )
    user = create_user
    create_membership(project, user)
    signin(user)

    visit root_path
    click_on "My Projects"
    find(".table").click_on("Amazeo 1.1")
    expect(page).to have_content("Amazeo 1.1")
  end

  scenario "User can only see projects he is a member of" do
    user = create_user
    project1 = create_project
    project2 = create_project
    membership = create_membership(project1, user)
    signin(user)
    visit projects_path
    expect(page).to have_content(project1.name)
    expect(page).to have_no_content(project2.name)
  end

  scenario "User edits a project" do
    project = Project.create!(
      name: "Amazeo 1.1"
    )
    user = create_user
    create_membership(project, user, role: "Owner")
    signin(user)

    visit root_path
    click_on "My Projects"
    find(".table").click_on("Amazeo 1.1")
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
    project = Project.create!(
      name: "Amazeo 1.1"
    )
    user = create_user
    create_membership(project, user, role: "Owner")
    signin(user)

    visit root_path
    click_on "My Projects"
    find(".table").click_on("Amazeo 1.1")
    click_on "Edit"
    fill_in "Name", with: ""
    click_on "Update Project"
    expect(page).to have_content("Edit project")
    expect(page).to have_content("Name can't be blank")
    click_on "gCamp"
    expect(page).to have_content("Amazeo 1.1")
  end

  scenario "User deletes a project and associated memberships, tasks and comments" do
    project = Project.create!(
      name: "Amazeo 1.1"
    )
    user = create_user
    create_membership(project, user, role: "Owner")

    3.times do
      task = create_task(project)
      1.times do
        create_comment(task, user)
      end
    end
    signin(user)

    visit root_path
    click_on "My Projects"
    find(".table").click_on("Amazeo 1.1")
    expect(page).to have_content("1 Member")
    expect(page).to have_content("3 Tasks")
    expect(Comment.count).to eq(3)
    click_on "Delete"
    expect(page).to have_content("Project was successfully destroyed.")
    expect(page).to have_no_content("Amazeo 1.1")
    expect(Membership.count).to eq(0)
    expect(Task.count).to eq(0)
    expect(Comment.count).to eq(0)
  end

end
