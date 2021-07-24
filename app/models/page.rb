class Page < ApplicationRecord
  enum status: { draft: 1, published: 2 }
  # tags
  acts_as_taggable_on :tags
end
