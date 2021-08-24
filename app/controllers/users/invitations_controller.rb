class Users::InvitationsController < Devise::InvitationsController
  before_action :hide_all_navbars

  def update
    super
  end

  def edit
    super
  end
end
