require 'rails_helper'

feature "Tasks" do

  scenario "User creates a task" do
    visit root_path
    click_on "Tasks"
    expect(page).to have_no_content("Create task")
    click_on "Create Task"
    fill_in "Description", with: "Create task"
    fill_in "Due date", with: "15/12/2014"
    click_on "Create Task"
    expect(page).to have_content("Task was successfully created.")
    expect(page).to have_content("Create task")
    expect(page).to have_content("12/15/2014")
    click_on "Back"
    click_on "All"
    expect(page).to have_content("Create task")
    expect(page).to have_content("12/15/2014")
  end

  scenario "User creates a task without a description" do
    visit root_path
    click_on "Tasks"
    expect(page).to have_no_content("12/15/2014")
    click_on "Create Task"
    fill_in "Due date", with: "15/12/2014"
    click_on "Create Task"
    expect(page).to have_content("New task")
    expect(page).to have_content("Description can't be blank")
    click_on "Tasks"
    expect(page).to have_no_content("12/15/2014")
  end

  scenario "User views a task" do
    Task.create!(
      description: "View task",
      due_date: "17/08/2014"
    )

    visit root_path
    click_on "Tasks"
    click_on "All"
    expect(page).to have_content("View task")
    expect(page).to have_content("08/17/2014")
    click_on "Show"
    expect(page).to have_content("View task")
    expect(page).to have_content("08/17/2014")
  end

  scenario "User edits a task" do
    Task.create!(
      description: "Edit task",
      due_date: "02/04/2014"
    )

    visit root_path
    click_on "Tasks"
    click_on "All"
    expect(page).to have_content("Edit task")
    expect(page).to have_content("04/02/2014")
    click_on "Edit"
    fill_in "Description", with: "Edited task"
    fill_in "Due date", with: "16/08/2014"
    check "Complete"
    click_on "Update Task"
    expect(page).to have_content("Task was successfully updated.")
    expect(page).to have_content("Edited task")
    expect(page).to have_content("True")
    expect(page).to have_content("08/16/2014")
    expect(page).to have_no_content("Edit task")
    expect(page).to have_no_content("04/02/2014")
    click_on "Back"
    click_on "All"
    expect(page).to have_content("Edited task")
    expect(page).to have_content("True")
    expect(page).to have_content("08/16/2014")
    expect(page).to have_no_content("Edit task")
    expect(page).to have_no_content("04/02/2014")
  end

  scenario "User edits a task to have no description" do
    Task.create!(
      description: "Edit task",
      due_date: "02/04/2014"
    )

    visit root_path
    click_on "Tasks"
    click_on "All"
    expect(page).to have_content("Edit task")
    expect(page).to have_content("04/02/2014")
    click_on "Edit"
    fill_in "Description", with: ""
    click_on "Update Task"
    expect(page).to have_content("Edit task")
    expect(page).to have_content("Description can't be blank")
    click_on "Tasks"
    click_on "All"
    expect(page).to have_content("Edit task")
  end

  scenario "User deletes a task" do
    Task.create!(
      description: "Delete task",
      due_date: "16/09/2014",
      complete: false
    )

    visit root_path
    click_on "Tasks"
    expect(page).to have_content("Delete task")
    expect(page).to have_content("False")
    expect(page).to have_content("09/16/2014")
    click_on "Destroy"
    expect(page).to have_content("Task was successfully destroyed.")
    click_on "All"
    expect(page).to have_no_content("Delete task")
    expect(page).to have_no_content("False")
    expect(page).to have_no_content("09/16/2014")
  end
end
