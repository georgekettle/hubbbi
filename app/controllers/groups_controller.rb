class GroupsController < ApplicationController
  include Groupable # for set_selected_group method

  before_action :set_group, only: [:show, :edit, :update, :destroy, :settings]

  def index
    @groups = current_user.groups
    hide_navbar
    hide_desktop_navbar
  end

  def show
    # grab from concern or from params instead
    # session[:selected_group] = @group
    @current_user_group_member = current_user.group_members.find_by(group: @group)
    @courses = @current_user_group_member.courses
    @courses = @group.courses if @current_user_group_member.role == ('admin' || 'editor')
  end

  def new
    @group = Group.new
    set_selected_group(@group)
    authorize @group
    hide_navbar
    hide_desktop_navbar
  end

  def create
    @group = Group.new(group_params)
    set_selected_group(@group)
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
    params.require(:group).permit(:name, :cover)
  end

  def set_group
    @group = Group.find(params[:id])
    set_selected_group(@group)
    authorize @group
  end
end
