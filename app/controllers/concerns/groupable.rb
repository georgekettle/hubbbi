module Groupable
  extend ActiveSupport::Concern

  included do
    before_action :set_current_group, unless: :skip_setting_current_group?
  end

  def set_current_group
    current_group = current_user.groups.find_by_subdomain(request.subdomain) if request.subdomain.present?

    if current_group.present?
      Current.group = current_group
      Current.group_member = current_user.group_members.find_by(group: current_group)
    elsif current_user.present?
      redirect_to groups_url(subdomain: 'www')
    else
      redirect_to new_user_session
    end
  end

  private

  def skip_setting_current_group?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^home$)|(^errors$)/
  end
end
