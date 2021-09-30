class GroupMembersController < ApplicationController
  before_action :set_group, only: [:new, :create, :index]
  before_action :set_group_member, only: [:show, :edit, :update, :destroy, :edit_avatar]

  def show
    @back_link = group_group_members_path(@group_member.group)
    @current_user_group_member = current_user.group_members.find_by(group: @group_member.group)
  end

  def index
    @group_members = @group.group_members
  end

  def edit
  end

  def update
    if @group_member.update(group_member_params)
      redirect_back fallback_location: group_group_members_path(@group_member.group), notice: "#{@group_member.user.full_name_or_email} was successfully updated"
    else
      redirect_back fallback_location: group_group_members_path(@group_member.group), alert: "Oops, there was an error updating user #{@group_member.user.full_name_or_email}"
    end
  end

  def destroy
    @group_member.destroy

    if @group_member.user == current_user
      redirect_to groups_path, notice: "You successfully removed yourself from #{@group_member.group.name.capitalize}"
    else
      if request.referrer == group_member_url(@group_member)
        redirect_to group_group_members_path(@group_member.group), notice: "You successfully removed #{@group_member.user.full_name_or_email} from the group"
      else
        redirect_back fallback_location: group_group_members_path(@group_member.group), notice: "You successfully removed #{@group_member.user.full_name_or_email} from the group"
      end
    end
  end

  def edit_avatar
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
    params.require(:group_member).permit(:role, :email, :avatar, user_attributes: [ :id, :full_name, :display_name ])
  end
end
