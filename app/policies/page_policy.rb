class PagePolicy < ApplicationPolicy
  def show?
    course_member? || admin_or_editor?
  end

  def create?
    admin_or_editor?
  end

  def update?
    admin_or_editor?
  end

  def destroy?
    admin_or_editor?
  end

  def edit_sections?
    admin_or_editor?
  end

  private

  def course_member?
    record.course_members.where(group_member: {user: user})
  end

  def admin_or_editor?
    record.group_members.find_by(user: user, role: [:admin, :editor])
  end
end
