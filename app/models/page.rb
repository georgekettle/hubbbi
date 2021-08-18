class Page < ApplicationRecord
  has_one :course

  # targeting child associations of pages
  has_many :sections, -> { order(:position) }, dependent: :destroy
  has_many :section_elements, through: :sections
  has_many :page_references, :through => :section_elements, :source => :element, :source_type => 'PageReference'
  has_many :pages, through: :page_references

  # targeting parent association of page
  has_one :page_reference, dependent: :destroy
  has_one :section_element, through: :page_reference, dependent: :destroy
  has_one :section, through: :section_element
  has_one :page, through: :section

  has_one_attached :cover

  # status
  enum status: { draft: 0, published: 1 }
  # tags
  acts_as_taggable_on :tags

  def parent_page
    page
  end

  def child_pages
    pages
  end

  def has_parent?
    !!page
  end

  def ancestors
    pages = []
    current_page = self
    while current_page.has_parent?
      pages << current_page unless current_page == self
      current_page = current_page.parent_page
    end
    pages.reverse
  end

  def belonging_to_course
    course = self.course || nil
    page = self
    until course
      page = page.page
      course = page.course if page.course
    end
    course
  end

  def course_members
    belonging_to_course.course_members
  end

  def group_members
    belonging_to_course.group.group_members
  end
end
