class AudiosController < ApplicationController
  before_action :set_audio, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    if @audio.update(audio_params)
      redirect_to edit_sections_page_path(@audio.page), notice: "Audio successfully updated"
    else
      render :edit, alert: "Oops... Something went wrong when updating audio"
    end
  end

  def destroy
    @audio.destroy
    redirect_to edit_sections_page_path(@audio.page), notice: "Audio successfully deleted"
  end

  private

  def set_audio
    @audio = Audio.find(params[:id])
    authorize @audio.section
  end

  def audio_params
    params.require(:audio).permit(:title, :file, :cover, :tag_list)
  end
end
