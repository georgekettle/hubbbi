class Content < ApplicationRecord
  has_many :content_permissions, dependent: :destroy
  has_many :permissions, through: :content_permissions
  belongs_to :group, optional: true

  enum status: { draft: 1, published: 2 }

  # infinite self nesting capability
  acts_as_nested_set
  # tags
  acts_as_taggable_on :tags
end
