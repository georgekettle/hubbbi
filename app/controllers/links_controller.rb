class LinksController < ApplicationController
  before_action :set_linkable, only: [:new, :create]

  def create
    @link = @linkable.links.new(link_params)
    authorize @linkable, :links?
    if @link.save
      redirect_to @linkable, notice: "Link successfully created"
    else
      render 'group_members/links/new', alert: "Oops... Something went wrong when creating the link"
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :title, :subtitle)
  end
end
