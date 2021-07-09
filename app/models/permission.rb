class Permission < ApplicationRecord
  belongs_to :group
  has_many :group_member_permissions, dependent: :destroy
  has_many :group_members, through: :group_member_permissions
  has_many :content_permissions, dependent: :destroy
  has_many :contents, through: :content_permissions
end
