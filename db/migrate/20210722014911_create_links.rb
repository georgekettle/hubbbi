class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :url, null: false
      t.string :title, null: false
      t.string :subtitle
      t.references :linkable, polymorphic: true

      t.timestamps
    end
  end
end
