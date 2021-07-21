class GroupMembersController < ApplicationController
  before_action :set_group, only: [:new, :create, :index]

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

  def create
    # invite user to be used as user in group member
    @group_member = @group.group_members.new(group_member_params)
    @group_member.group = @group

    authorize @group_member

    if @group_member.save
      redirect_to new_group_group_member_path(@group), notice: "Invitation sent to #{@group_member.email}"
    else
      redirect_to new_group_group_member_path(@group), alert:  @group_member.errors.messages.values.flatten.join("\n")
    end
  end

  private

  def email_is_member?
    @group.users.find_by(email: @email)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def group_member_params
    params.require(:group_member).permit(:role, :email)
  end
end
