module Groups
  class InvitesController < ApplicationController
    include Groupable

    def new
      @group = Group.find(params[:group_id])
      set_selected_group(@group)
      @invite = Invite.new()
      authorize current_user_group_member, :create?
    end

    private

    def current_user_group_member
      @group.group_members.find_by(user: current_user)
    end
  end
end
