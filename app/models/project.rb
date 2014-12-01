class Project < ActiveRecord::Base

  has_many :tasks, dependent: :destroy
  has_many :memberships, dependent: :destroy

  validates :name, presence: true

end
