class VideosController < ApplicationController
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
    authorize @video.section
  end

  def video_params
    params.require(:video).permit(:title, :file, :url)
  end
end
