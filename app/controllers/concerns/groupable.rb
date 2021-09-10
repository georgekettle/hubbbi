module Groupable
  extend ActiveSupport::Concern

  included do
    before_action :set_current_group, unless: :skip_setting_current_group?
  end

  def set_current_group
    current_group = Group.find_by(id: session[:selected_group_id])

    if current_group.present?
      Current.group = current_group
    elsif current_user.present?
      redirect_to authenticated_root_path
    else
      redirect_to new_user_session
    end
  end

  private

  def skip_setting_current_group?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^home$)|(^errors$)/
  end
end
