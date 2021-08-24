class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :set_selected_group # needed for navbar
  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back fallback_location: root_path
  end

  def default_url_options
    # for Heroku and meta.yml/meta tags with meta_image
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^home$)|(^errors$)/
  end

  def configure_permitted_parameters
    keys = [:full_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
    devise_parameter_sanitizer.permit(:accept_invitation, keys: keys)
  end

  def hide_navbar
    @hide_navbar = true
  end

  def hide_desktop_navbar
    @hide_desktop_navbar = true
  end

  def hide_all_navbars
    hide_navbar
    hide_desktop_navbar
  end
end
