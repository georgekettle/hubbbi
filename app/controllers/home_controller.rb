class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  skip_before_action :set_current_group, only: :home

  def home
    hide_navbar
    hide_desktop_navbar
  end
end
