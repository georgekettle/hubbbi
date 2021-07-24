class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :settings]

  def index
    @groups = current_user.groups
  end

  def show
    session[:selected_group] = @group
    @current_user_group_member = current_user.group_members.find_by(group: @group)
    @courses = @current_user_group_member.courses
    @courses = @group.courses if @current_user_group_member.role == ('admin' || 'editor')
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = Group.new(group_params)
    @group.group_members.new(user: current_user, role: :admin)
    authorize @group
    if @group.save
      redirect_to @group, notice: "Your group has successfully been created"
    else
      render :new, alert: "Oops... Something went wrong when creating your group"
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: "Your group has successfully been updated"
    else
      render :edit, alert: "Oops... Something went wrong when updating your group"
    end
  end

  def settings
  end

  def destroy
    if @group.destroy
      redirect_to groups_path, notice: "Your group has successfully been destroyed"
    else
      render :settings, alert: "Oops... Something went wrong when deleting your group"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    @group = Group.find(params[:id])
    authorize @group
  end
end
