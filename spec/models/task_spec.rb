require 'rails_helper'

describe Task do
  it "Creates a task with future date" do
    task = Task.new(
      description: "Test the app",
      due_date: Time.now + 7.days
    )

    task.valid?
    expect(task.errors[:due_date].present?).to eq (false)
  end

  it "Creates a task with past date" do
    task = Task.new(
      description: "Test the app",
      due_date: Time.now - 7.days
    )

    task.valid?
    expect(task.errors[:due_date].present?).to eq (true)
  end

  it "Edits a task with a past date" do
    task = nil

    travel_to 3.weeks.ago do
      task = Task.create!(
        description: "Test the app",
        due_date: Time.now
      )
    end

    task.description = "Test the app again"
    task.valid?
    expect(task.errors[:due_date].present?).to eq(false)
  end
end
