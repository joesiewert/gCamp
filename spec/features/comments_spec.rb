require 'rails_helper'

feature "Comments" do

  scenario "Add a comment" do
    project = create_project
    user = create_user
    task = create_task(project)
    comment = Faker::Lorem.sentence(5)
    signin(user)

    visit root_path
    click_on "Projects"
    click_on project.name
    click_on "1 Task"
    within(".badge") do
      expect(page).to have_content("0")
    end
    click_on task.description
    fill_in "comment_message", with: comment
    click_on "Add Comment"
    within(".row") do
      expect(page).to have_content(user.full_name)
      expect(page).to have_content(comment)
    end
    find(".breadcrumb").click_on("Tasks")
    within(".badge") do
      expect(page).to have_content("1")
    end
  end

  scenario "Add a comment with no message" do
    project = create_project
    task = create_task(project)
    user = create_user
    signin(user)

    visit project_tasks_path(project)
    within(".badge") do
      expect(page).to have_content("0")
    end
    click_on task.description
    click_on "Add Comment"
    visit project_tasks_path(project)
    within(".badge") do
      expect(page).to have_content("0")
    end
  end

end
