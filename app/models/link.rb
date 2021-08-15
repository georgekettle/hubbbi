class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, optional: true
  has_one :section_element, :as =>:element
  has_one :section, through: :section_element
  has_one :page, through: :section

  validates :url, presence: true, format: { with: /\A#{URI::regexp}\z/, message: "is invalid" }
  validates :title, presence: true
end
