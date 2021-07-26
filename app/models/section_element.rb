class SectionElement < ApplicationRecord
  belongs_to :section
  belongs_to :element, polymorphic: true, dependent: :destroy
end
