class CreateSectionElements < ActiveRecord::Migration[6.1]
  def change
    create_table :section_elements do |t|
      t.references :section, null: false, foreign_key: true
      t.references :element, polymorphic: true, null: false

      t.timestamps
    end
  end
end
