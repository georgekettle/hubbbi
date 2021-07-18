class GroupMembersController < ApplicationController
  before_action :set_group, only: [:new, :index]

  def show
    @group_member = GroupMember.find(params[:id])
    authorize @group_member
  end

  def index
    @group_members = @group.group_members
  end

  def new
    @group_member = GroupMember.new(group: @group)
    authorize @group_member
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
