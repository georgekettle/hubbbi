class SectionsController < ApplicationController
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
      render json: {
        section: render_to_string(partial: 'sections/section', locals: { section: @section }),
        dropzone: render_to_string(partial: 'sections/dropzone', locals: { position: @section.position })
      }
    else
      redirect_to edit_sections_page_path(@page), alert: "Oops, there was an error creating this section"
    end
  end

  private

  def section_params
    params.require(:section).permit(:position)
    # params.require(:section).permit(:position, section_elements: [element: {:element_type}])
  end

  # def section_element_params
  #   params.require(:section_element).permit(:element_type)
  # end

  def element_params
    params.require(:element).permit()
  end
end
