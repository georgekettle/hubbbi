class TextsController < ApplicationController
  def update
    @text = Text.find(params[:id])
    authorize @text.page
    if @text.update(text_params)
      redirect_to edit_sections_page_path(@text.page), notice: "Text section successfully updated"
    else
      redirect_to edit_sections_page_path(@text.page), alert: "Oops, there was an error creating this section"
    end
  end

  private

  def text_params
    params.require(:text).permit(:content)
  end
end
