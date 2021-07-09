class CreateContents < ActiveRecord::Migration[6.1]
  def change
    create_table :contents do |t|
      t.string :title
      t.string :subtitle
      t.integer :status, null: false, default: 0

      t.integer :parent_id, null: true, index: true
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      # optional fields
      t.integer :depth, null: false, default: 0
      t.integer :children_count, null: false, default: 0

      t.timestamps
    end
  end
end
