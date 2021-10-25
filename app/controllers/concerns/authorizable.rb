module Authorizable
  extend ActiveSupport::Concern

  included do
    include Pundit
    # Pundit: white-list approach.
    after_action :verify_authorized, except: :index, unless: :skip_pundit?
    # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to groups_url(subdomain: 'www')
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^home$)|(^errors$)/
  end
end
