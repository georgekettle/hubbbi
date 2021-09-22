module MediaHelper
  def currently_playing
    return nil unless Current.group.present?
    group_member = current_user.group_members.find_by(group: Current.group)
    group_member.media_plays.first
  end

  def media_queue
    return [] unless Current.group.present?
    group_member = current_user.group_members.find_by(group: Current.group)
    group_member.media_plays.drop(1)
  end
end
