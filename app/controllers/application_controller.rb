class ApplicationController < ActionController::Base
  include Authenticatable
  include Authorizable

  def default_url_options
    # for Heroku and meta.yml/meta tags with meta_image
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  private

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
