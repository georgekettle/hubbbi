class CreateSubInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_invites do |t|
      t.references :invite, null: false, foreign_key: true
      t.references :invitable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
