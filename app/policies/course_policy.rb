class CoursePolicy < ApplicationPolicy
  def show?
    course_member? || group_admin_or_editor?
  end

  private

  def course_member?
    record.group_members.find_by(user: user)
  end

  def group_admin_or_editor?
    record.group_members.find_by(role: ["admin", "editor"], user: user)
  end
end
