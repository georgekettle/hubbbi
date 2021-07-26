class Section < ApplicationRecord
  belongs_to :page
  has_many :section_elements, dependent: :destroy
  has_many :elements, :through => :section_elements, :source => :element, :source_type => 'PageReference'

  def element_type
    section_elements.first.element.class.name
  end
end
