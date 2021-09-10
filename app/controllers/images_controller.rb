class ImagesController < ApplicationController
  before_action :set_image, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    if @image.update(image_params)
      redirect_to edit_sections_page_path(@image.page), notice: "Image successfully updated"
    else
      render :edit, alert: "Oops... Something went wrong when updating image"
    end
  end

  def destroy
    @image.destroy
    redirect_to edit_sections_page_path(@image.page), notice: "You successfully deleted your image"
  end

  private

  def set_image
    @image = Image.find(params[:id])
    authorize @image.section
  end

  def image_params
    params.require(:image).permit(:title, :picture)
  end
end
