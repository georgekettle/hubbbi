class RemoveDisplayNameFromGroupMembers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :display_name
  end
end
