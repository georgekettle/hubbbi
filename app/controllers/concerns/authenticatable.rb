module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
  end

  private

  def configure_permitted_parameters
    keys = [:full_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
  end
end
