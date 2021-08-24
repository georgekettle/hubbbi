module Groupable
  extend ActiveSupport::Concern

  def set_selected_group(record)
    @selected_group = record.class == Group ? record : record.group
    UpdateUserSelectedGroupJob.perform_later(@selected_group, current_user) unless current_user.selected_group == @selected_group
  end
end
