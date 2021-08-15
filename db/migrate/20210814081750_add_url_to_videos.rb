class AddUrlToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :url, :string
  end
end
