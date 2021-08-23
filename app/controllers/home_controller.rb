class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    hide_navbar
    hide_desktop_navbar
  end
end
