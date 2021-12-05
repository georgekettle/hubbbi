class AddParentIdToPages < ActiveRecord::Migration[6.1]
  def change
    add_column :pages, :parent_id, :integer
  end
end

