class Course < ApplicationRecord
  belongs_to :group
  belongs_to :page

  validates :title, presence: true
end
