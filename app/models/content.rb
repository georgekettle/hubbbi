class Content < ApplicationRecord
  acts_as_nested_set
  enum status: { draft: 1, published: 2 }
end
