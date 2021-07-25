class Page < ApplicationRecord
  has_many :courses
  has_many :course_members, through: :courses
  has_many :group_members, through: :course_members

  # status
  enum status: { draft: 0, published: 1 }
  # tags
  acts_as_taggable_on :tags
end
