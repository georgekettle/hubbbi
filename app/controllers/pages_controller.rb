class PagesController < ApplicationController
  before_action :set_page, only: [:edit, :update, :show, :edit_sections, :destroy]

  def show
    redirect_to @page.course if @page.course
    set_breadcrumbs
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

  def destroy
    @page.destroy
    redirect_path = @page.has_parent? ? @page.parent_page : @page.belonging_to_course
    redirect_to redirect_path, notice: "You successfully deleted your page"
  end

  def edit_sections
    hide_navbar
  end

  private

  def set_breadcrumbs
    breadcrumb "Back to course", course_path(@page.belonging_to_course)
    @page.ancestors.each do |page|
      breadcrumb page.title.truncate(20), page_path(page)
    end
    breadcrumb @page.title.truncate(20), page_path(@page)
  end

  def set_page
    @page = Page.find(params[:id])
    authorize @page
  end

  def page_params
    params.require(:page).permit(:title, :subtitle, :status, :cover, :tag_list)
  end
end
