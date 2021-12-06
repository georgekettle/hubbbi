class CreateProgressions < ActiveRecord::Migration[6.1]
  def change
    create_table :progressions do |t|
      t.references :progressable, polymorphic: true, null: false
      t.integer :current, null: false, default: 0
      t.integer :total, null: false, default: 100
      t.references :group_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
