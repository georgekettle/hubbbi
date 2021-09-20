class MediaPlayPolicy < ApplicationPolicy
  def create?
    record.user == user
  end
end
