class Section < ApplicationRecord
  belongs_to :page
  has_many :section_elements, -> { order(position: :asc) }, dependent: :destroy
  has_many :page_references, :through => :section_elements, :source => :element, :source_type => 'PageReference'
  has_many :pages, through: :page_references
  has_many :tags, through: :pages
  has_many :texts, :through => :section_elements, :source => :element, :source_type => 'Text'
  has_many :images, :through => :section_elements, :source => :element, :source_type => 'Image'
  has_many :videos, :through => :section_elements, :source => :element, :source_type => 'Video'
  has_many :links, :through => :section_elements, :source => :element, :source_type => 'Link'

  enum section_type: [:page_reference, :text, :image, :video, :link]

  acts_as_list scope: :page

  def tags_by_popularity
    tags.where('taggings_count > 0').order(taggings_count: :desc).uniq
  end

  def elements
    page_references + texts + images + videos + links
   end
end
