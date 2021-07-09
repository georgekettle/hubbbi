class GroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :group

  enum role: { member: 1, editor: 2, admin: 3 }
end
