class CourseMemberPolicy < ApplicationPolicy
  def destroy?
    belongs_to_user? || group_admin_or_editor?
  end

  private

  def group_admin_or_editor?
    record.group.group_members.find_by(role: ["admin", "editor"], user: user)
  end

  def belongs_to_user?
    record.user == user
  end
end
