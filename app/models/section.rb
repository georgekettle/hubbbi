class Section < ApplicationRecord
  belongs_to :page
  has_many :section_elements, -> { order(position: :asc) }, dependent: :destroy
  has_many :page_references, :through => :section_elements, :source => :element, :source_type => 'PageReference'
  has_many :texts, :through => :section_elements, :source => :element, :source_type => 'Text'
  has_many :images, :through => :section_elements, :source => :element, :source_type => 'Image'
  has_many :videos, :through => :section_elements, :source => :element, :source_type => 'Video'

  enum section_type: [:page_reference, :text, :image, :video]

  acts_as_list scope: :page

  def elements
    page_references + texts + images + videos
   end
end
