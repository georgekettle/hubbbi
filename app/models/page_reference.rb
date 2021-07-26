class PageReference < ApplicationRecord
  include ActionView::Helpers

  belongs_to :page, dependent: :destroy
  has_one :section_element, :as =>:element
  has_one :section, :through => :section_element

  def image_path
    page.cover.attached? ? cl_image_path(page.cover.key) : asset_path('default_cover.svg')
  end
end
