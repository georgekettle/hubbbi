class MediaPlayPolicy < ApplicationPolicy
  def create?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def skip_queue?
    update?
  end

  def reorder?
    update?
  end
end
