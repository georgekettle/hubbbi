class CreateContentPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :content_permissions do |t|
      t.references :permission, null: false, foreign_key: true
      t.references :content, null: false, foreign_key: true

      t.timestamps
    end
  end
end
