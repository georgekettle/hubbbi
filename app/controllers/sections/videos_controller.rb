module Sections
  class VideosController < ApplicationController
    include Groupable # for set_selected_group method

    before_action :set_section, only: [:new, :create]

    def new
      @video = Video.new
    end

    def create
      @video = Video.new(video_params)
      section_element = @section.section_elements.new(element: @video)
      if @section.save
        redirect_to edit_sections_page_path(@section.page), notice: "New video successfully created"
      else
        render :new, alert: "Oops... Something went wrong when creating video"
      end
    end

    private

    def video_params
      params.require(:video).permit(:title, :url, :file)
    end

    def set_section
      @section = Section.find(params[:section_id])
      set_selected_group(@section)
      authorize @section.page
    end
  end
end
