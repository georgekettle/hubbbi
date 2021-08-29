class GroupMemberPolicy < ApplicationPolicy
  def show?
    record.group.users.include?(user)
  end

  def create?
    admin_or_editor?
  end

  def update?
    admin? || belongs_to_user?
  end

  def destroy?
    admin? || belongs_to_user?
  end

  def edit_avatar?
    admin? || belongs_to_user?
  end

  def links?
    belongs_to_user? || admin?
  end

  def admin_or_editor?
    group = record.group
    user.group_members.find_by(group: group, role: [:admin, :editor])
  end

  def admin?
    group = record.group
    user.group_members.find_by(group: group, role: [:admin])
  end

  def belongs_to_user?
    record.user == user
  end
end
