class AddPositionToPageReference < ActiveRecord::Migration[6.1]
  def change
    add_column :section_elements, :position, :integer
    SectionElement.order(:updated_at).each.with_index(1) do |element, index|
      element.update_column :position, index
    end
  end
end

