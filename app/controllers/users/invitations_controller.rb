class Users::InvitationsController < Devise::InvitationsController
  before_action :hide_all_navbars

  def update
    super
  end

  def edit
    super
  end

  private

  def hide_all_navbars
    hide_navbar
    hide_desktop_navbar
  end
end
