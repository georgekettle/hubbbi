class GroupMemberPermission < ApplicationRecord
  belongs_to :permission
  belongs_to :group_member
end
