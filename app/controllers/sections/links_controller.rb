module Sections
  class LinksController < ApplicationController
    before_action :set_section, only: [:new, :create]

    def new
      @link = Link.new
    end

    def create
      @link = Link.new(link_params)
      if @link.save
        @section.links << @link
        redirect_to edit_sections_page_path(@section.page), notice: "New link successfully created"
      else
        render :new, alert: "Oops... Something went wrong when creating link", status: :unprocessable_entity
      end
    end

    private

    def link_params
      params.require(:link).permit(:url, :title, :subtitle, :cover)
    end

    def set_section
      @section = Section.find(params[:section_id])
      authorize @section.page
    end
  end
end
