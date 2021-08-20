class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :courses, dependent: :destroy
  has_many :pages, through: :courses

  has_one_attached :cover

  validates :name, presence: true
end
