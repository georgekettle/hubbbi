class AddHideMediaPlayerToGroupMember < ActiveRecord::Migration[6.1]
  def change
    add_column :group_members, :hide_media_player, :boolean, null: false, default: false
  end
end
