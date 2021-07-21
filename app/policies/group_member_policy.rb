class GroupMemberPolicy < ApplicationPolicy
  def show?
    record.group.users.include?(user)
  end

  def create?
    group_admin_or_editor?
  end

  private

  def group_admin_or_editor?
    group = record.group
    user.group_members.find_by(group: group, role: [:admin, :editor])
  end
end
