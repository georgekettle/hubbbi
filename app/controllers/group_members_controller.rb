class GroupMembersController < ApplicationController
  def show
    @group_member = GroupMember.find(params[:id])
    authorize @group_member
  end

  def index
    @group = Group.find(params[:group_id])
    @group_members = @group.group_members
  end

  def new

  end
end
