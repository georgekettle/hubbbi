class PagesController < ApplicationController
  before_action :set_page, only: :edit

  def edit
  end

  private

  def set_page
    @page = Page.find(params[:id])
    authorize @page
  end

  def page_params
    params.require(:page).permit(:title, :subtitle, :banner, :status)
  end
end
