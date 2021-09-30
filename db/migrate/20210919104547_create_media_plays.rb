class CreateMediaPlays < ActiveRecord::Migration[6.1]
  def change
    create_table :media_plays do |t|
      t.integer :position
      t.decimal :progress, precision: 10, scale: 2, default: 0.00
      t.references :group_member, null: false, foreign_key: true
      t.boolean :complete, default: false
      t.references :mediable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
