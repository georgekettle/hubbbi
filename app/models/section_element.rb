class SectionElement < ApplicationRecord
  belongs_to :section
  belongs_to :element, polymorphic: true, dependent: :destroy
  has_one :page, through: :section

  acts_as_list scope: :section
end
