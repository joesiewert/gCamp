# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Task.delete_all
#
# 10.times do
#   task = Task.new
#   task.description = Faker::Lorem.sentence(1)
#   task.complete = [true, false].sample
#   task.due_date = Faker::Date.forward(14)
#   task.save
# end
#
# User.delete_all
#
# 10.times do
#   user = User.new
#   user.first_name = Faker::Name.first_name
#   user.last_name = Faker::Name.last_name
#   user.email = Faker::Internet.free_email
#   user.save
# end
#
# Project.delete_all
#
# 5.times do
#   project = Project.new
#   project.name = "#{Faker::App.name} #{Faker::App.version}"
#   project.save
# end

User.delete_all
Project.delete_all
Task.delete_all
Comment.delete_all
Membership.delete_all

# admin = User.create!(
#   first_name: 'Admin',
#   last_name: 'User',
#   email: 'admin@example.com',
#   password: 'password'
#   admin: true
# )

owner = User.create!(
  first_name: 'Owner',
  last_name: 'User',
  email: 'owner@example.com',
  password: 'password'
)

member = User.create!(
  first_name: 'Member',
  last_name: 'User',
  email: 'member@example.com',
  password: 'password'
)

user = User.create!(
  first_name: 'Basic',
  last_name: 'User',
  email: 'user@example.com',
  password: 'password'
)

multiple_owners = Project.create!(name: 'Multiple Owners')
Membership.create!(
  project: multiple_owners,
  user: owner,
  role: 'Owner'
)

Membership.create!(
  project: multiple_owners,
  user: user,
  role: 'Owner'
)

Membership.create!(
  project: multiple_owners,
  user: member,
  role: 'Member'
)

task1 = Task.create!(
  description: "Write 3 comments",
  project: multiple_owners,
  due_date: 4.days.from_now
)

task2 = Task.create!(
  description: "Write 1 comment",
  project: multiple_owners,
  due_date: 5.days.from_now
)

3.times do
  Comment.create!(
    task: task1,
    user: owner,
    message: Faker::Lorem.sentence
  )
end

Comment.create!(
  task: task2,
  user: member,
  message: Faker::Lorem.sentence
)

single_owner = Project.create!(name: 'Single Owner')
Membership.create!(
  project: single_owner,
  user: owner,
  role: 'Owner'
)

Membership.create!(
  project: single_owner,
  user: member,
  role: 'Member'
)
