class ApplicationController < ActionController::Base
  include Authenticatable
  include Authorizable
  include Groupable
  include NavbarHideable

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
