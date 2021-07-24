class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.references :group, null: false, foreign_key: true
      t.references :page, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
