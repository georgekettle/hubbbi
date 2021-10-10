class SectionsController < ApplicationController
  before_action :set_section, only: [:update, :destroy]

  def create
    @page = Page.find(params[:page_id])
    @section = @page.sections.new(section_params)
    create_text_element if @section.section_type == "text" # needed for form fields
    authorize @section

    if @section.save
      render json: { section: render_to_string(partial: 'sections/section', locals: { section: @section, editable: true }) }
    else
      redirect_to edit_sections_page_path(@page), alert: "Oops, there was an error creating this section"
    end
  end

  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html  { redirect_to edit_sections_page_path(@section.page), notice: "Section has been successfully updated" }
        format.json  { render json: { section: render_to_string(partial: 'sections/section.html.erb', :formats => :html, locals: { section: @section, editable: true }) }.to_json }
      else
        format.html { redirect_to edit_sections_page_path(@section.page), alert: "Oops, there was an error updating this section" }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section.destroy
    redirect_to edit_sections_page_path(@section.page), notice: "Section has successfully been deleted"
  end

  private

  def create_text_element
    @section.texts.new
  end

  def set_section
    @section = Section.find(params[:id])
    authorize @section
  end

  def section_params
    params.require(:section).permit(:position, :section_type, data: [:format])
  end
end
