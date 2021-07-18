class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user.group_members.find_by(group: record)
  end

  def create?
    true
  end
end
