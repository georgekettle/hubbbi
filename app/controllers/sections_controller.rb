class SectionsController < ApplicationController
  before_action :set_section, only: [:update, :destroy]

  def create
    @page = Page.find(params[:page_id])
    @section = @page.sections.new(section_params)
    klass = params[:element][:element_type].constantize
    if klass == PageReference
      new_page = Page.new(title: "Example page", subtitle: "Subtitle")
      @section_element = @section.section_elements.new(element: klass.new(page: new_page)) if new_page
    else
      @section_element = @section.section_elements.new(element: klass.new(element_params))
    end

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

  def set_section
    @section = Section.find(params[:id])
    authorize @section
  end

  def section_params
    params.require(:section).permit(:position)
  end

  def element_params
    params.require(:element).permit()
  end
end