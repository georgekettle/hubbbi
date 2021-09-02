module ActiveStorage
  class BlobPolicy < ApplicationPolicy
    def destroy?
      true
    end
  end
end
