class Group < ApplicationRecord
  include Invitable

  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  has_many :courses, dependent: :destroy
  has_many :pages, through: :courses

  has_one_attached :cover

  validates :name, :subdomain, presence: true
  validates :subdomain, uniqueness: true
  validates :subdomain,
            format: { with: %r{\A[a-z](?:[a-z0-9-]*[a-z0-9])?\z}i, message: "%{value} is not a valid subdomain" },
            length: { in: 1..63 }

  # used for invitable
  def add_user(user)
    existing_member = GroupMember.find_by(user: user, group: self)
    existing_member ? existing_member : GroupMember.create(user: user, group: self)
  end

  def set_subdomain
    update subdomain: name.parameterize(separator: '')
  end
end
