class AddSectionTypeToSection < ActiveRecord::Migration[6.1]
  def change
    add_column :sections, :section_type, :integer, default: 0
  end
end
