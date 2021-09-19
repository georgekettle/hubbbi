class InvitesController < ApplicationController
  def destroy
    @invite = Invite.find(params[:id])
    @group = @invite.invitable
    authorize @group
    @invite.destroy

    redirect_to group_group_members_path(@group, section: 'invites'), notice: "Invite deleted"
  end
end
