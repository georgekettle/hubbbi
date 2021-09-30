class Audio < ApplicationRecord
  include Mediable
  has_one :section_element, :as =>:element
  has_one :section, through: :section_element
  has_one :page, through: :section

  has_one_attached :file, :service => :cloudinary_video
  has_one_attached :cover

  validates :title, presence: true
end
