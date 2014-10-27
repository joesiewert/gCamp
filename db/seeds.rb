# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Task.delete_all

10.times do
  task = Task.new
  task.description = Faker::Lorem.sentence(1)
  task.complete = [true, false].sample
  task.due_date = Faker::Date.forward(14)
  task.save
end
