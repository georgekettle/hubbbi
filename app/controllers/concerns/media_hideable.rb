module MediaHideable
  extend ActiveSupport::Concern

  included do
    # before_action :hide_media_player, unless: :skip_hide_media_player?
  end

  private

  def hide_media_player
    @hide_media_player = true
  end

  def skip_hide_media_player?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^home$)|(^errors$)/
  end
end
