class SessionsController < Devise::SessionsController
  before_action :hide_all_navbars
end
