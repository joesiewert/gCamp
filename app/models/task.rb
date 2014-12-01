class Task < ActiveRecord::Base

  belongs_to :project
  has_many :comments, dependent: :destroy

  validates :description, presence: true
  validate :date_check, on: :create

  #Task date can't be set to a date in the past
  def date_check
    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "can't be before today")
    end
  end
end
