class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.references :page, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
