class Membership < ActiveRecord::Base
  before_destroy :not_last_owner?

  belongs_to :project
  belongs_to :user

  validates :user_id, presence: true, uniqueness: {scope: :project_id,
    message: "has already been added"}

  def not_last_owner?
    if self.role == "Member" || project.memberships.where(role: "Owner").count > 1
      true #before_destroy will delete
    else
      false #before_destroy won't delete
    end
  end

end
