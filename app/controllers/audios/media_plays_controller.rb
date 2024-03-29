module Audios
  class MediaPlaysController < ApplicationController
    before_action :set_audio, only: [:create, :add_to_queue]

    def create
      current_group_member = current_user.group_members.find_by(group: Current.group)
      current_group_member.current_media_plays.first&.complete!
      @media_play = MediaPlay.new(media_play_params)
      @media_play.group_member = current_group_member
      @media_play.mediable = @audio
      authorize @media_play
      @media_play.save!

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: Current.group }
      end
    end

    def add_to_queue
      @media_play = MediaPlay.new
      @media_play.group_member = Current.group_member
      @media_play.mediable = @audio
      authorize @media_play, :create?
      @media_play.save!

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: Current.group }
      end
    end

    private

    def set_audio
      @audio = Audio.find(params[:audio_id])
    end

    def media_play_params
      params.require(:media_play).permit(:position, :progress, :complete)
    end
  end
end
