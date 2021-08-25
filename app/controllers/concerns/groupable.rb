module Groupable
  extend ActiveSupport::Concern

  def set_selected_group(record)
    @selected_group = record.class == Group ? record : record.group
    if @selected_group.id.present? && current_user.selected_group != @selected_group
      UpdateUserSelectedGroupJob.perform_later(@selected_group, current_user)
    end
  end
end
