class AddSubdomianToGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :subdomain, :string
    Group.all.each do |group|
      group.update_column :subdomain, group.name.gsub(/\s+/, "")
    end
  end
end
