class GroupPolicy < ApplicationPolicy
  def show?
    group_member?
  end

  def create?
    true
  end

  def update?
    admin_or_editor?
  end

  def destroy?
    admin?
  end

  def settings?
    admin_or_editor?
  end

  private

  def admin?
    user.group_members.find_by(group: record, role: :admin)
  end

  def admin_or_editor?
    user.group_members.find_by(group: record, role: [:admin, :editor])
  end

  def group_member?
    user.group_members.find_by(group: record)
  end
end
