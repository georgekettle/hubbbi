class UserPolicy < ApplicationPolicy
  def update?
    record == user
  end

  def edit_avatar?
    record == user
  end
end
