class TextsController < ApplicationController
  def update
    @text = Text.find(params[:id])
    authorize @text.page
    respond_to do |format|
      if @text.update(text_params)
        format.json  { render json: { success: true }.to_json }
        format.html { redirect_to edit_sections_page_path(@text.page), notice: "Text section successfully updated" }
      else
        format.json { render json: @text.errors, status: :unprocessable_entity }
        format.html { redirect_to edit_sections_page_path(@text.page), alert: "Oops, there was an error creating this section" }
      end
    end
  end

  private

  def text_params
    params.require(:text).permit(:content)
  end
end
