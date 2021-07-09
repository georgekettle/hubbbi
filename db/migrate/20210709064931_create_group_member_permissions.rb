class CreateGroupMemberPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :group_member_permissions do |t|
      t.references :permission, null: false, foreign_key: true
      t.references :group_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
