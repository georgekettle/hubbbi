class Text < ApplicationRecord
  has_one :section_element, :as =>:element
  has_one :section, through: :section_element
  has_one :page, through: :section

  has_rich_text :content
end
