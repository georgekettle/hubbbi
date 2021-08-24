class LinksController < ApplicationController
  include Groupable # for set_selected_group method

  before_action :set_linkable, only: [:new, :create]
  before_action :set_link, only: [:edit, :update, :destroy]

  def create
    @link = @linkable.links.new(link_params)
    authorize @linkable, :links?
    if @link.save
      redirect_to @linkable, notice: "Link successfully created"
    else
      render 'group_members/links/new', alert: "Oops... Something went wrong when creating the link"
    end
  end

  def edit
  end

  def update
    if @link.update(link_params)
      if @link.linkable
        redirect_to @link.linkable, notice: "Your link has successfully been updated"
      else
        redirect_to edit_sections_page_path(@link.page), notice: "Your link has successfully been updated"
      end
    else
      render :edit, alert: "Oops... Something went wrong when updating your link"
    end
  end

  def destroy
    @link.destroy
    if @link.linkable
      redirect_to @link.linkable, notice: "Link was successfully deleted"
    else
      redirect_to edit_sections_page_path(@link.page), notice: "Link was successfully deleted"
    end
  end

  private

  def set_link
    @link = Link.find(params[:id])
    authorize @link.linkable, :links? if @link.linkable
    set_selected_group(@link.linkable.group) if @link.linkable
    authorize @link.page if @link.page
    set_selected_group(@link.page) if @link.page
  end

  def link_params
    params.require(:link).permit(:url, :title, :subtitle)
  end
end
