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
  has_many :pdfs, :through => :section_elements, :source => :element, :source_type => 'Pdf'
  has_many :audios, :through => :section_elements, :source => :element, :source_type => 'Audio'

  enum section_type: [:page_reference, :text, :image, :video, :link, :pdf, :audio]

  delegate :group, to: :page, allow_nil: true

  acts_as_list scope: :page

  def tags_by_popularity
    count_hash = {}
    tags.each do |tag|
      if count_hash[tag.id]
        count_hash[tag.id] += 1
      else
        count_hash[tag.id] = 1
      end
    end
    tags.sort_by{ |tag| -count_hash[tag.id] }.uniq # potentially make quicker
  end

  def elements
    page_references + texts + images + videos + links + pdfs + audios
  end
end
