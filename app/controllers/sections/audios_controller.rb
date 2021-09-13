module Sections
  class AudiosController < ApplicationController
    before_action :set_section, only: [:new, :create]

    def new
      @audio = Audio.new
    end

    def create
      @audio = Audio.new(audio_params)
      section_element = @section.section_elements.new(element: @audio)
      if @section.save
        redirect_to edit_sections_page_path(@section.page), notice: "New audio successfully created"
      else
        render :new, alert: "Oops... Something went wrong when creating audio"
      end
    end

    private

    def audio_params
      params.require(:audio).permit(:title, :file)
    end

    def set_section
      @section = Section.find(params[:section_id])
      authorize @section.page
    end
  end
end
