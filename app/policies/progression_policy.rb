class ProgressionPolicy < ApplicationPolicy
  def create?
    belongs_to_current_group_member?
  end

  def update?
    belongs_to_current_group_member?
  end

  private

  def belongs_to_current_group_member?
    record.group_member == Current.group_member
  end
end
