class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :hide_navbar

  def not_found
    render status: 404
  end

  def internal_server_error
    render status: 500
  end
end
