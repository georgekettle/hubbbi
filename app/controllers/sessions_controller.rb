class SessionsController < Devise::SessionsController
  before_action :hide_all_navbars
  before_action :set_current_group_from_subdomain, only: :new

  private

  def set_current_group_from_subdomain
    Current.group = Group.find_by_subdomain(request.subdomain) if request.subdomain.present?
  end
end
