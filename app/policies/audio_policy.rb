class AudioPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.select do |audio|
        user.courses.include?(audio.page.belonging_to_course)
      end
    end
  end

  def update?
    group_admin_or_editor?
  end

  private

  def group_admin_or_editor?
    record.course.group.group_members.find_by(role: ["admin", "editor"], user: user).present?
  end
end
