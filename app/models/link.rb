class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  validates :url, format: { with: /\A#{URI::regexp}\z/,
    message: "is invalid" }
end
