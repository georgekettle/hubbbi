class MediaPlaysController < ApplicationController
  before_action :set_media_play, only: [:update, :skip_queue]

  def update
    @media_play.update!(media_play_params)

    respond_to do |format|
      format.turbo_stream {}
      format.html { redirect_back fallback_location: Current.group }
    end
  end

  def skip_queue
    @media_plays = @media_play.group_member.current_media_plays
    @media_plays.first&.complete!
    @media_play.move_to_top

    respond_to do |format|
      format.turbo_stream {}
      format.html { redirect_back fallback_location: Current.group }
    end
  end

  private

  def set_media_play
    @media_play = MediaPlay.find(params[:id])
    authorize @media_play
  end

  def media_play_params
    params.require(:media_play).permit(:position, :progress, :complete)
  end
end
