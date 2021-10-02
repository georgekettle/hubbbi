class ApplicationController < ActionController::Base
  include Authenticatable
  include Authorizable
  include NavbarHideable
  include MediaHideable
  include Groupable

  before_action :set_body_padding

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  private

  def set_body_padding
    @no_body_padding = false
  end
end
