class GroupsController < ApplicationController
  skip_before_action :set_current_group, except: %i[edit update destroy settings]
  before_action :set_group, only: %i[show edit update destroy settings]
  before_action :hide_media_player, only: [:index, :new]

  def index
    @groups = current_user.groups
    hide_navbar
    hide_desktop_navbar
  end

  def show
    session[:selected_group_id] = @group.id
    set_current_group
    @courses = Current.group_member.courses
    @current_group = Current.group
  end

  def new
    @group = Group.new
    authorize @group
    hide_all_navbars
  end

  def create
    @group = Group.new(group_params)
    @group.group_members.new(user: current_user, role: :admin)
    authorize @group
    if @group.save
      redirect_to group_path(@group), notice: "Your group has successfully been created"
    else
      hide_all_navbars
      hide_media_player
      render :new, status: :unprocessable_entity, alert: "Oops... Something went wrong when creating your group"
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: "Your group has successfully been updated"
    else
      render :edit, status: :unprocessable_entity, alert: "Oops... Something went wrong when updating your group"
    end
  end

  def settings
  end

  def destroy
    if @group.destroy
      redirect_to groups_path, notice: "Your group has successfully been destroyed"
    else
      render :settings, status: :unprocessable_entity, alert: "Oops... Something went wrong when deleting your group"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :cover)
  end

  def set_group
    @group = Group.find(params[:id])
    authorize @group
  end
end
