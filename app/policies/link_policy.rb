class LinkPolicy < ApplicationPolicy
  def update?
    group_admin_or_editor?
  end

  private

  def group_admin_or_editor?
    record.page.belonging_to_course.group.group_members.find_by(role: ["admin", "editor"], user: user).present?
  end
end
