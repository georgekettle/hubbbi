class AddGroupToContent < ActiveRecord::Migration[6.1]
  def change
    add_reference :contents, :group, null: true, foreign_key: true
  end
end
