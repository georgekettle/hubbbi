module Sections
  class PagesController < ApplicationController
    before_action :set_section, only: [:new, :create]

    def new
      @page = Page.new
      authorize @section.page
    end

    def create
      authorize @section.page
      @page = Page.new(page_params)
      @page.parent_id = @section.page.id
      page_reference = PageReference.new(page: @page)
      section_element = @section.section_elements.new(element: page_reference)
      if @section.save
        redirect_to edit_sections_page_path(@page.parent), notice: "New page successfully created"
      else
        render :new, alert: "Oops... Something went wrong when creating page"
      end
    end

    private

    def page_params
      params.require(:page).permit(:title, :subtitle, :cover, :tag_list)
    end

    def set_section
      @section = Section.find(params[:section_id])
    end
  end
end
