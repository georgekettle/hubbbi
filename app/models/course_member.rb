class CourseMember < ApplicationRecord
  belongs_to :course
  belongs_to :group_member
  has_one :user, through: :group_member
  has_one :group, through: :course

  acts_as_list scope: :group_member

  validates :group_member, uniqueness: { scope: :course, message: 'Is already in this course' }
end
