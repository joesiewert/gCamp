require 'rails_helper'

feature "Tasks" do

  before :each do
    @test_date = Time.now + 7.days
    @test_date_expect = @test_date.strftime("%m/%d/%Y")

    @project = Project.create!(
      name: "gCamp 1.1"
    )
    user = create_user
    create_membership(@project, user)
    signin(user)
  end

  scenario "User creates a task" do
    visit root_path
    click_on "Projects"
    find(".table").click_on("gCamp 1.1")
    click_on "0 Tasks"
    expect(page).to have_no_content("Task 1")
    click_on "Create Task"
    fill_in "Description", with: "Task 1"
    fill_in "Due date", with: @test_date
    click_on "Create Task"
    expect(page).to have_content("Task was successfully created.")
    expect(page).to have_content("Task 1")
    expect(page).to have_content(@test_date_expect)
    expect(page).to have_content("False")
    within(".breadcrumb") do
      click_on "Tasks"
    end
    expect(page).to have_content("gCamp 1.1")
    expect(page).to have_content("Task 1")
    expect(page).to have_content(@test_date_expect)
    expect(page).to have_content("False")
  end

  scenario "User creates a task without a description and date in past" do
    visit root_path
    click_on "Projects"
    find(".table").click_on("gCamp 1.1")
    click_on "0 Tasks"
    click_on "Create Task"
    fill_in "Due date", with: "01/11/2014"
    click_on "Create Task"
    expect(page).to have_content("New task")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Due date can't be before today")
    click_on "gCamp"
    find(".table").click_on("gCamp 1.1")
    expect(page).to have_content "0 Tasks"
  end

  scenario "User views a task" do
    Task.create!(
      description: "Task 1",
      due_date: @test_date,
      project_id: @project.id,
      complete: false
    )

    visit root_path
    click_on "Projects"
    find(".table").click_on("gCamp 1.1")
    click_on "1 Task"
    click_on "All"
    expect(page).to have_content("Task 1")
    expect(page).to have_content(@test_date_expect)
    expect(page).to have_content("False")
    click_on "Task 1"
    expect(page).to have_content("Task 1")
    expect(page).to have_content(@test_date_expect)
    expect(page).to have_content("False")
  end

  scenario "User edits a task" do
    Task.create!(
      description: "Task 1",
      due_date: @test_date,
      project_id: @project.id,
      complete: false
    )

    visit root_path
    click_on "Projects"
    find(".table").click_on("gCamp 1.1")
    click_on "1 Task"
    click_on "All"
    expect(page).to have_content("Task 1")
    expect(page).to have_content(@test_date_expect)
    expect(page).to have_content("False")
    click_on "Edit"
    fill_in "Description", with: "Task 2"
    fill_in "Due date", with: @test_date + 1.day
    check "Complete"
    click_on "Update Task"
    expect(page).to have_content("Task was successfully updated.")
    expect(page).to have_content("Task 2")
    expect(page).to have_content("True")
    expect(page).to have_content((@test_date + 1.day).strftime("%m/%d/%Y"))
    expect(page).to have_no_content("Task 1")
    expect(page).to have_no_content(@test_date_expect)
    expect(page).to have_no_content("False")
    within(".breadcrumb") do
      click_on "Tasks"
    end
    click_on "All"
    expect(page).to have_content("Task 2")
    expect(page).to have_content("True")
    expect(page).to have_content((@test_date + 1.day).strftime("%m/%d/%Y"))
    expect(page).to have_no_content("Task 1")
    expect(page).to have_no_content(@test_date_expect)
    expect(page).to have_no_content("False")
  end

  scenario "User edits a task to have no description" do
    Task.create!(
      description: "Task 1",
      due_date: @test_date,
      project_id: @project.id,
      complete: false
    )

    visit root_path
    click_on "Projects"
    find(".table").click_on("gCamp 1.1")
    click_on "1 Task"
    click_on "All"
    expect(page).to have_content("Task 1")
    expect(page).to have_content(@test_date_expect)
    expect(page).to have_content("False")
    click_on "Edit"
    fill_in "Description", with: ""
    click_on "Update Task"
    expect(page).to have_content("Edit task")
    expect(page).to have_content("Description can't be blank")
    click_on "gCamp"
    find(".table").click_on("gCamp 1.1")
    click_on "1 Task"
    click_on "All"
    expect(page).to have_content("Task 1")
    expect(page).to have_content(@test_date_expect)
    expect(page).to have_content("False")
  end

  scenario "User deletes a task and associated comments" do
    task = Task.create!(
      description: "Task 1",
      due_date: @test_date,
      project_id: @project.id,
      complete: false
    )
    user = create_user

    5.times do
      create_comment(task, user)
    end

    visit root_path
    click_on "Projects"
    find(".table").click_on("gCamp 1.1")
    click_on "1 Task"
    expect(page).to have_content("Task 1")
    expect(page).to have_content("False")
    expect(page).to have_content(@test_date_expect)
    within(".badge") do
      expect(page).to have_content("5")
    end
    find('.glyphicon').click
    expect(page).to have_content("Task was successfully destroyed.")
    click_on "All"
    expect(page).to have_no_content("Task 1")
    expect(page).to have_no_content("False")
    expect(page).to have_no_content(@test_date_expect)
    within(".breadcrumb") do
      click_on "gCamp 1.1"
    end
    expect(page).to have_content("0 Tasks")
    expect(Comment.all.count).to eq(0)
  end

end
