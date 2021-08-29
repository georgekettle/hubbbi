module Sections
  class PdfsController < ApplicationController
    include Groupable # for set_selected_group method

    before_action :set_section, only: [:new, :create]

    def new
      @pdf = Pdf.new
    end

    def create
      @pdf = Pdf.new(pdf_params)
      section_element = @section.section_elements.new(element: @pdf)
      if @section.save
        redirect_to edit_sections_page_path(@section.page), notice: "New pdf successfully created"
      else
        render :new, alert: "Oops... Something went wrong when creating pdf"
      end
    end

    private

    def pdf_params
      params.require(:pdf).permit(:url, :title, :subtitle)
    end

    def set_section
      @section = Section.find(params[:section_id])
      set_selected_group(@section)
      authorize @section.page
    end
  end
end
