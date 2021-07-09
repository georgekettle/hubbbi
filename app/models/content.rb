class Content < ApplicationRecord
  has_many :content_permissions, dependent: :destroy
  has_many :permissions, through: :content_permissions

  enum status: { draft: 1, published: 2 }

  acts_as_nested_set
end
