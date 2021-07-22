class LinksController < ApplicationController
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
      redirect_to @link.linkable, notice: "Your link has successfully been updated"
    else
      render :edit, alert: "Oops... Something went wrong when updating your link"
    end
  end

  def destroy
    @link.destroy
    redirect_to @link.linkable, notice: "Link was successfully deleted"
  end

  private

  def set_link
    @link = Link.find(params[:id])
    authorize @link.linkable, :links?
  end

  def link_params
    params.require(:link).permit(:url, :title, :subtitle)
  end
end
