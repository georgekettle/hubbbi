class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :permissions, dependent: :destroy
  has_one :content, dependent: :destroy

  has_one_attached :cover

  def name
    super.capitalize
  end
end
