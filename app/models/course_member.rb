class CourseMember < ApplicationRecord
  belongs_to :course
  belongs_to :group_member
end
