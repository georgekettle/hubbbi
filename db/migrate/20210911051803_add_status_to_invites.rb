class AddStatusToInvites < ActiveRecord::Migration[6.1]
  def change
    add_column :invites, :status, :integer, null: false, default: 0
  end
end
