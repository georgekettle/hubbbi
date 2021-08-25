class ApplicationController < ActionController::Base
  include Authenticatable
  include Authorizable
  include NavbarHideable

  def default_url_options
    # for Heroku and meta.yml/meta tags with meta_image
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end
end
