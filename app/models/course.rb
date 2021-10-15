class Course < ApplicationRecord
  include SubInvitable

  belongs_to :group
  belongs_to :page, dependent: :destroy
  has_many :course_members, dependent: :destroy
  has_many :group_members, through: :course_members

  has_one_attached :cover

  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 50, maximum: 200 }

  def add_user(group_member)
    CourseMember.create(group_member: group_member, course: self) unless CourseMember.find_by(group_member: group_member, course: self)
  end
end
