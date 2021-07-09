class GroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :group_member_permissions, dependent: :destroy
  has_many :permissions, through: :group_member_permissions

  enum role: { member: 1, editor: 2, admin: 3 }
end
