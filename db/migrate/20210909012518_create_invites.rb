class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.string :email
      t.integer :sender_id
      t.integer :recipient_id
      t.string :token
      t.references :invitable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
