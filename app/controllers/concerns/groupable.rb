module Groupable
  extend ActiveSupport::Concern

  def set_selected_group(record)
    @selected_group = record.class == Group ? record : record.group
  end
end
