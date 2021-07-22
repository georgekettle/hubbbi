class GroupMemberPolicy < ApplicationPolicy
  def show?
    record.group.users.include?(user)
  end

  def create?
    group_admin_or_editor?
  end

  def update?
    group_admin? || belongs_to_user?
  end

  def destroy?
    group_admin? || belongs_to_user?
  end

  private

  def belongs_to_user?
    record.user == user
  end

  def group_admin?
    group = record.group
    user.group_members.find_by(group: group, role: [:admin])
  end

  def group_admin_or_editor?
    group = record.group
    user.group_members.find_by(group: group, role: [:admin, :editor])
  end
end
