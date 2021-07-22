class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :url, presence: true, format: { with: /\A#{URI::regexp}\z/, message: "is invalid" }
  validates :title, presence: true
end
