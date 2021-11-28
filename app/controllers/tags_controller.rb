class TagsController < ApplicationController
  def index
    @pages = policy_scope(Page.tagged_with(params[:name]))
    @audios = policy_scope(Audio.tagged_with(params[:name]))
  end
end
