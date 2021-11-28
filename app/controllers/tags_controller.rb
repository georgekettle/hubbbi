class TagsController < ApplicationController
  def index
    @pages = policy_scope(Page.tagged_with(params[:name]))
    @audios = policy_scope(Audio.tagged_with(params[:name]))
    @videos = policy_scope(Video.tagged_with(params[:name]))
  end
end
