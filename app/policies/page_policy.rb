class PagePolicy < ApplicationPolicy
  def show?
    course_member? || admin_or_editor?
  end

  def update?
    admin_or_editor?
  end

  private

  def course_member?
    record.group_members.where(user: user) # must update this!
    # must figure out how to get the course and course member of current user
  end

  def admin_or_editor?
    record.group.group_members.find_by(user: user, role: [:admin, :editor])
  end
end