module MediaHelper
  def currently_playing
    return nil unless Current.group_member.present?
    Current.group_member.current_media_plays.first
  end

  def media_queue
    return [] unless Current.group_member.present?
    Current.group_member.current_media_plays.drop(1)
  end
end
