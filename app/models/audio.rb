class Audio < ApplicationRecord
  has_one :section_element, :as =>:element
  has_one :section, through: :section_element
  has_one :page, through: :section

  has_one_attached :file

  validates :title, presence: true
end
