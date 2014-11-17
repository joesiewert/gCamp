require 'rails_helper'

feature "Tasks" do

  before :each do
    @test_date = Time.now + 7.days
    @test_date_expect = @test_date.strftime("%m/%d/%Y")
  end

  scenario "User creates a task" do
    visit root_path
    click_on "Tasks"
    expect(page).to have_no_content("Create task")
    click_on "Create Task"
    fill_in "Description", with: "Create task"
    fill_in "Due date", with: @test_date
    click_on "Create Task"
    expect(page).to have_content("Task was successfully created.")
    expect(page).to have_content("Create task")
    expect(page).to have_content(@test_date_expect)
    click_on "Back"
    click_on "All"
    expect(page).to have_content("Create task")
    expect(page).to have_content(@test_date_expect)
  end

  scenario "User creates a task without a description and date in past" do
    visit root_path
    click_on "Tasks"
    click_on "Create Task"
    fill_in "Due date", with: "01/11/2014"
    click_on "Create Task"
    expect(page).to have_content("New task")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Due date can't be before today")
    click_on "Tasks"
    expect(page).to have_no_content("11/01/2014")
  end

  scenario "User views a task" do
    Task.create!(
      description: "View task",
      due_date: @test_date
    )

    visit root_path
    click_on "Tasks"
    click_on "All"
    expect(page).to have_content("View task")
    expect(page).to have_content(@test_date_expect)
    click_on "Show"
    expect(page).to have_content("View task")
    expect(page).to have_content(@test_date_expect)
  end

  scenario "User edits a task" do
    Task.create!(
      description: "Edit task",
      due_date: @test_date
    )

    visit root_path
    click_on "Tasks"
    click_on "All"
    expect(page).to have_content("Edit task")
    expect(page).to have_content(@test_date_expect)
    click_on "Edit"
    fill_in "Description", with: "Edited task"
    fill_in "Due date", with: @test_date + 1.day
    check "Complete"
    click_on "Update Task"
    expect(page).to have_content("Task was successfully updated.")
    expect(page).to have_content("Edited task")
    expect(page).to have_content("True")
    expect(page).to have_content((@test_date + 1.day).strftime("%m/%d/%Y"))
    expect(page).to have_no_content("Edit task")
    expect(page).to have_no_content(@test_date_expect)
    click_on "Back"
    click_on "All"
    expect(page).to have_content("Edited task")
    expect(page).to have_content("True")
    expect(page).to have_content((@test_date + 1.day).strftime("%m/%d/%Y"))
    expect(page).to have_no_content("Edit task")
    expect(page).to have_no_content(@test_date_expect)
  end

  scenario "User edits a task to have no description" do
    Task.create!(
      description: "Edit task",
      due_date: @test_date
    )

    visit root_path
    click_on "Tasks"
    click_on "All"
    expect(page).to have_content("Edit task")
    expect(page).to have_content(@test_date_expect)
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
      due_date: @test_date,
      complete: false
    )

    visit root_path
    click_on "Tasks"
    expect(page).to have_content("Delete task")
    expect(page).to have_content("False")
    expect(page).to have_content(@test_date_expect)
    click_on "Destroy"
    expect(page).to have_content("Task was successfully destroyed.")
    click_on "All"
    expect(page).to have_no_content("Delete task")
    expect(page).to have_no_content("False")
    expect(page).to have_no_content(@test_date_expect)
  end
end
