class SectionPolicy < ApplicationPolicy
  def create?
    admin_or_editor?
  end

  def destroy?
    admin_or_editor?
  end

  private

  def admin_or_editor?
    record.page.group_members.find_by(user: user, role: [:admin, :editor])
  end
end
