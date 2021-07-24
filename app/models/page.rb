class Page < ApplicationRecord
  has_many :courses
  has_many :groups, through: :courses
  # status
  enum status: { draft: 0, published: 1 }
  # tags
  acts_as_taggable_on :tags
end
