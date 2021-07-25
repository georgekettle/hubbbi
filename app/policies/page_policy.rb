class PagePolicy < ApplicationPolicy
  def update?
    admin_or_editor?
  end

  private

  def admin_or_editor?
    record.group_members.find_by(user: user, role: [:admin, :editor])
  end
end
