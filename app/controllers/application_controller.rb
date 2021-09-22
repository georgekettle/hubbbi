class ApplicationController < ActionController::Base
  include Authenticatable
  include Authorizable
  include NavbarHideable
  include MediaHideable
  include Groupable

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
