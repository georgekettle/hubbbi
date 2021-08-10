class SectionElementsController < ApplicationController
  def index
    @section = Section.find(params[:section_id])
    authorize @section, :update?
  end

  def update
    @element = SectionElement.find(params[:id])
    authorize @element.section
    respond_to do |format|

      if @element.update(element_params)
        format.json  { render json: { success: true }.to_json }
        format.html  { redirect_to edit_sections_page_path(@element.page), notice: "Your item has been successfully reordered" }
      else
        format.json { render json: @element.errors, status: :unprocessable_entity }
        format.html { redirect_to edit_sections_page_path(@element.page), alert: "Oops, there was an error reordering this item" }
      end
    end
  end

  private

  def element_params
    params.require(:section_element).permit(:position)
  end
end
