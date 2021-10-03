class PasswordsController < Devise::PasswordsController
  before_action :hide_all_navbars
end
