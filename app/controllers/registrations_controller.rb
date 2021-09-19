class RegistrationsController < Devise::RegistrationsController
  before_action :hide_all_navbars

  def new
    check_invite
    super
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?

    # check for token -- from invite
    @token = params[:invite_token]
    if @token != nil
      # create invitable member
      invite = Invite.find_by_token(@token)
      if invite
        invitable = invite.invitable
        invitable_resource = invitable.add_user(resource)
        invite.sub_invites.each do |sub_invite|
          sub_invite.invitable.add_user(invitable_resource)
        end
        invite.update(status: 'accepted')
      end
    end

    # do normal registration things
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def check_invite
    @token = params[:invite_token]
    if @token
      invite = Invite.find_by_token(@token)
      flash[:alert] = "This invite is invalid! But you can still sign up ☺️" unless invite
    end
  end
end
