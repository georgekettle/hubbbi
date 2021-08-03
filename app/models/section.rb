class Section < ApplicationRecord
  belongs_to :page
  has_many :section_elements, dependent: :destroy
  has_many :elements, :through => :section_elements, :source => :element, :source_type => 'PageReference'

  enum section_type: [:page_reference]

  acts_as_list scope: :page
end
