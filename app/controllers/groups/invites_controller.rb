module Groups
  class InvitesController < ApplicationController
    before_action :set_group, only: [:new, :create]

    def new
      @invite = Invite.new
      @invite.sub_invites.build
    end

    def create
      @invite = Invite.new(invite_params)
      @invite.invitable = @group
      @invite.sender = current_user
      add_courses
      invitable_name = @group.name
      if @invite.save
        if !!@invite.recipient
          InviteMailer.existing_user_invite(@invite, invitable_name).deliver
          group_member = @group.add_user(@invite.recipient)
          @invite.sub_invites.each do |sub_invite|
            sub_invite.invitable.add_user(group_member)
          end
        else
          InviteMailer.new_user_invite(@invite, invitable_name, new_user_registration_url(:invite_token => @invite.token, subdomain: @group.subdomain)).deliver #send the invite data to our mailer to deliver the email
        end
        redirect_to group_group_members_path(@group, section: 'invites'), notice: "Invite sent"
      else
        render :new
      end
    end

    private

    def invite_params
      params.require(:invite).permit(:email)
    end

    def set_group
      @group = Group.find(params[:group_id])
      authorize current_user_group_member, :create?
    end

    def current_user_group_member
      @group.group_members.find_by(user: current_user)
    end

    def add_courses
      if params[:invite][:invitable]
        params[:invite][:invitable].each do |course_id|
          course = Course.find(course_id)
          @invite.sub_invites.new(invitable: course)
        end
      end
    end
  end
end
