module Groups
  class InvitesController < ApplicationController
    include Groupable

    before_action :set_group, only: [:new, :create]

    def new
      @invite = Invite.new()
    end

    def create
      @invite = Invite.new(invite_params) # Make a new Invite
      @invite.invitable = @group
      @invite.sender = current_user # set the sender to the current user
      invitable_name = @group.name
      if @invite.save
        if @invite.recipient != nil
          InviteMailer.existing_user_invite(@invite, invitable_name).deliver
          @group.add_user(@invite.recipient)
        else
          InviteMailer.new_user_invite(@invite, invitable_name, new_user_registration_url(:invite_token => @invite.token)).deliver #send the invite data to our mailer to deliver the email
        end
        redirect_to group_group_members_path(@group), notice: "Invite sent"
      else
        render :new
        # oh no, creating an new invitation failed
      end
    end

    private

    def invite_params
      params.require(:invite).permit(:email)
    end

    def set_group
      @group = Group.find(params[:group_id])
      set_selected_group(@group)
      authorize current_user_group_member, :create?
    end

    def current_user_group_member
      @group.group_members.find_by(user: current_user)
    end
  end
end
