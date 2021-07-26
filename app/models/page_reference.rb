class PageReference < ApplicationRecord
  belongs_to :page
  has_one :section_element, :as =>:element
  has_one :section, :through => :section_element
end
