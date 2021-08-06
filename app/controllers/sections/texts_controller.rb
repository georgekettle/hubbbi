module Sections
  class TextsController < ApplicationController
    before_action :set_section, only: [:new, :create]

    def create
      authorize @section.page
      @text = Text.new(text_params)
      section_element = @section.section_elements.new(element: @text)
      if @section.save
        redirect_to edit_sections_page_path(@section.page), notice: "New text successfully created"
      else
        render edit_sections_page_path(@section.page), alert: "Oops... Something went wrong when saving text"
      end
    end

    private

    def text_params
      params.require(:text).permit(:content)
    end

    def set_section
      @section = Section.find(params[:section_id])
    end
  end
end
