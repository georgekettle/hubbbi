class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :subtitle
      t.boolean :published

      t.timestamps
    end
  end
end
