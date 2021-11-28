class AudioPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.select do |audio|
        user.courses.include?(audio.page.belonging_to_course)
      end
    end
  end
end
