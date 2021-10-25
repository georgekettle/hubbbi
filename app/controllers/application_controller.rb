class ApplicationController < ActionController::Base
  include Turbo::Redirection
  include Authenticatable
  include Authorizable
  include NavbarHideable
  include MediaHideable
  include Groupable

  before_action :set_body_padding

  def default_url_options
    { host: ENV["DOMAIN"] || "lvh.me:3000" }
  end

  # protected

  def after_sign_in_path_for(resource)
    return signed_in_root_path(resource) if request.subdomain

    super
  end

  private

  def set_body_padding
    @no_body_padding = false
  end
end
