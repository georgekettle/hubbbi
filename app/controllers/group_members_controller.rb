class GroupMembersController < ApplicationController
  before_action :set_group, only: [:new, :create, :index]
  before_action :set_group_member, only: [:show, :update]

  def show
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

  def update
    if @group_member.update(group_member_params)
      redirect_to group_group_members_path(@group_member.group), notice: "#{@group_member.user.full_name_or_email} was successfully updated"
    else
      redirect_back fallback_location: group_group_members_path(@group_member.group), alert: "Oops, there was an error updating user #{@group_member.user.full_name_or_email}"
    end
  end

  private

  def email_is_member?
    @group.users.find_by(email: @email)
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_member
    @group_member = GroupMember.find(params[:id])
    authorize @group_member
  end

  def group_member_params
    params.require(:group_member).permit(:role, :email)
  end
end
