class AddSubdomianToGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :subdomain, :string
  end
end
