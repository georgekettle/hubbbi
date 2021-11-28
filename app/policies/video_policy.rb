class VideoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.select do |video|
        user.courses.include?(video.page.belonging_to_course)
      end
    end
  end
end
