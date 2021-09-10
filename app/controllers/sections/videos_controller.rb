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
      strong_params = params.require(:video).permit(:title, :url, :file)
      if params[:video][:is_upload] == "true"
        strong_params.except(:url)
      else
        strong_params.except(:file)
      end
    end

    def set_section
      @section = Section.find(params[:section_id])
      authorize @section.page
    end
  end
end
