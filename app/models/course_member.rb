class CourseMember < ApplicationRecord
  belongs_to :course
  belongs_to :group_member

  validates :group_member, uniqueness: { scope: :course, message: 'Is already in this course' }
end
