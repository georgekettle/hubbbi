class CreatePageReferences < ActiveRecord::Migration[6.1]
  def change
    create_table :page_references do |t|
      t.references :page, null: false, foreign_key: true

      t.timestamps
    end
  end
end
