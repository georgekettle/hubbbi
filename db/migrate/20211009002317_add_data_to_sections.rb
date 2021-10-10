class AddDataToSections < ActiveRecord::Migration[6.1]
  def change
    add_column :sections, :data, :jsonb
  end
end
