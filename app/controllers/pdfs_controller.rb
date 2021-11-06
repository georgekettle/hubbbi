class PdfsController < ApplicationController
  before_action :set_pdf, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    if @pdf.update(pdf_params)
      redirect_to edit_sections_page_path(@pdf.page), notice: "Pdf successfully updated"
    else
      render :edit, alert: "Oops... Something went wrong when updating pdf"
    end
  end

  def destroy
    @pdf.destroy
    redirect_to edit_sections_page_path(@pdf.page), notice: "You successfully deleted your pdf"
  end

  private

  def set_pdf
    @pdf = Pdf.find(params[:id])
    authorize @pdf.section
  end

  def pdf_params
    params.require(:pdf).permit(:title, :file, :cover)
  end
end
