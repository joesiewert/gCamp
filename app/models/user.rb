class User < ActiveRecord::Base

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  has_secure_password

  before_validation do |user|
    user.email = user.email.downcase.strip
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end
