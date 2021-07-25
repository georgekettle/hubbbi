class Section < ApplicationRecord
  belongs_to :page
  has_many :section_elements, dependent: :destroy
  # has_many :items, polymorphic: true, dependent: :destroy
  # belongs_to :sectionable, polymorphic: true, dependent: :destroy
end
