class GroupMemberPolicy < ApplicationPolicy
  def show?
    record.group.users.include?(user)
  end
end
