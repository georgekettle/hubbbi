module Sections
  class VideosController < ApplicationController
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
      strong_params = params.require(:video).permit(:title, :subtitle, :url, :file, :tag_list)

      if params[:video][:remote_video] == "true"
        strong_params.except(:file)
      else
        strong_params.except(:url)
      end
    end

    def set_section
      @section = Section.find(params[:section_id])
      authorize @section.page
    end
  end
end
