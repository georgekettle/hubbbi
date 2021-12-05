class Course < ApplicationRecord
  include SubInvitable
  include PgSearch::Model
  multisearchable against: [:title, :description]

  belongs_to :group
  belongs_to :page, dependent: :destroy
  has_many :course_members, dependent: :destroy
  has_many :group_members, through: :course_members

  has_one_attached :cover

  validates :title, presence: true

  def add_user(group_member)
    existing_member = CourseMember.find_by(group_member: group_member, course: self)
    existing_member ? existing_member : CourseMember.create(group_member: group_member, course: self)
  end
end
