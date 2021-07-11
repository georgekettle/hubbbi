class GroupMembersController < ApplicationController
  def show
    @group_member = GroupMember.find(params[:id])
    authorize @group_member
  end
end
