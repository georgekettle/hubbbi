class UpdateUserSelectedGroupJob < ApplicationJob
  queue_as :default

  def perform(group, user)
    selected_group_member = user.group_members.find_by(group: group)
    user.update(selected_group_member: selected_group_member) unless user.selected_group_member == selected_group_member
  end
end
