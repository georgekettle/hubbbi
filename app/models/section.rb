class Section < ApplicationRecord
  belongs_to :page
  belongs_to :sectionable, polymorphic: true, dependent: :destroy
end
