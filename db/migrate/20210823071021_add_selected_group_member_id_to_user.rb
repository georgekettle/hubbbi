class AddSelectedGroupMemberIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :selected_group_member, foreign_key: { to_table: :group_members }
  end
end
