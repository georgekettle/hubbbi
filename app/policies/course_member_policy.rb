class CourseMemberPolicy < ApplicationPolicy
  def destroy?
    group_admin_or_editor?
  end

  private

  def group_admin_or_editor?
    record.group.group_members.find_by(role: ["admin", "editor"], user: user)
  end
end
