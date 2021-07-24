class Page < ApplicationRecord
  has_many :courses
  has_many :groups, through: :courses

  enum status: { draft: 1, published: 2 }
  # tags
  acts_as_taggable_on :tags
end
