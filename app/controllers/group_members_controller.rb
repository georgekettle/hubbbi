class GroupMembersController < ApplicationController
  def show
    @group_member = GroupMember.find(params[:id])
  end
end
