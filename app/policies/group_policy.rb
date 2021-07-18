class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    group_member?
  end

  def create?
    true
  end

  def update?
    admin_or_editor?
  end

  private

  def admin_or_editor?
    user.group_members.find_by(group: record, role: [:admin, :editor])
  end

  def group_member?
    user.group_members.find_by(group: record)
  end
end
