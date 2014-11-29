class Membership < ActiveRecord::Base

  belongs_to :project
  belongs_to :user

  validates :user_id, presence: true, uniqueness: {scope: :project_id,
    message: "has already been added"}

end
