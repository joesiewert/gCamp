class User < ActiveRecord::Base

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships
  has_many :comments

  before_validation do |user|
    user.email = user.email.downcase.strip
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def project_member?(project)
    self.memberships.where(project_id: project.id).present?
  end

  def project_owner?(project)
    self.memberships.where(project_id: project.id, role: "Owner").present?
  end

  def admin?
    self.admin
  end

  def masked_tracker_token
    unless tracker_token.nil?
      "#{tracker_token[0..3]}#{"*" * (tracker_token.length-4)}"
    end
  end

end
