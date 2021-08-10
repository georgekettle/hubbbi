class Section < ApplicationRecord
  belongs_to :page
  has_many :section_elements, -> { order(position: :asc) }, dependent: :destroy
  has_many :page_references, :through => :section_elements, :source => :element, :source_type => 'PageReference'
  has_many :texts, :through => :section_elements, :source => :element, :source_type => 'Text'
  has_many :images, :through => :section_elements, :source => :element, :source_type => 'Image'

  enum section_type: [:page_reference, :text, :image]

  acts_as_list scope: :page

  def elements
    page_references + texts + images
   end
end
