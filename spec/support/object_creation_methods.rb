module ObjectCreationMethods

  def create_project
    Project.create!(
      name: Faker::App.name
    )
  end

  def create_user(overrides = {})
    User.create!({
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.free_email,
      password: Faker::Internet.password
    }.merge(overrides)
    )
  end

  def create_task(project)
    Task.create!(
      description: Faker::Lorem.sentence(1),
      due_date: Faker::Time.forward(14),
      complete: false,
      project: project
    )
  end

  def create_membership(project, user, overrides = {})
    Membership.create!({
      role: "Member",
      project: project,
      user: user
    }.merge(overrides)
    )
  end

  def create_comment(task, user)
    Comment.create!(
      message: Faker::Lorem.sentence(5),
      task: task,
      user: user
    )
  end

  def signin(user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"
  end

end
