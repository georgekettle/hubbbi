class Group < ApplicationRecord
  include Invitable

  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :courses, dependent: :destroy
  has_many :pages, through: :courses

  has_one_attached :cover

  validates :name, presence: true

  # used for invitable
  def add_user(user)
    existing_member = GroupMember.find_by(user: user, group: self)
    existing_member ? existing_member : GroupMember.create(user: user, group: self)
  end
end
