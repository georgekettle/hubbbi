class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :subtitle
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
