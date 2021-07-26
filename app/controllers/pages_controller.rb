class PagesController < ApplicationController
  before_action :set_page, only: [:edit, :update, :show]

  def show
    redirect_to @page.course if @page.course
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to @page, notice: "Page was successfully updated"
    else
      render :edit, alert: "Oops... Something went wrong when updating the page"
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
    authorize @page
  end

  def page_params
    params.require(:page).permit(:title, :subtitle, :status, :cover)
  end
end
