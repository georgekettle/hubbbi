module Sections
  class ImagesController < ApplicationController
    before_action :set_section, only: [:new, :create]

    def new
      @image = Image.new
    end

    def create
      @image = Image.new(image_params)
      section_element = @section.section_elements.new(element: @image)
      if @section.save
        redirect_to edit_sections_page_path(@section.page), notice: "New image successfully created"
      else
        render :new, alert: "Oops... Something went wrong when creating image"
      end
    end

    private

    def image_params
      params.require(:image).permit(:title, :picture)
    end

    def set_section
      @section = Section.find(params[:section_id])
      authorize @section.page
    end
  end
end
