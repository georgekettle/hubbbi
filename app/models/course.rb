class Course < ApplicationRecord
  belongs_to :group
  belongs_to :page
  has_many :course_members, dependent: :destroy
  has_many :group_members, through: :course_members

  has_one_attached :cover

  validates :title, presence: true
end
