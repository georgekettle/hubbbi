class RegistrationsController < Devise::RegistrationsController
  before_action :hide_all_navbars
end
