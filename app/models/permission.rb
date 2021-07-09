class Permission < ApplicationRecord
  belongs_to :group
  has_many :group_member_permissions, dependent: :destroy
  has_many :group_members, through: :group_member_permissions
end
