class VideosController < ApplicationController
  include Groupable # for set_selected_group method

  before_action :set_video, only: [:edit, :update]

  def edit
  end

  def update
    if @video.update(video_params)
      redirect_to edit_sections_page_path(@video.page), notice: "Video successfully updated"
    else
      render :edit, alert: "Oops... Something went wrong when updating video"
    end
  end

  private

  def set_video
    @video = Video.find(params[:id])
    set_selected_group(@video.section)
    authorize @video.section
  end

  def video_params
    strong_params = params.require(:video).permit(:title, :url, :file)
    if params[:video][:is_upload] == "true"
      strong_params.except(:url)
    else
      strong_params.except(:file)
    end
  end
end
