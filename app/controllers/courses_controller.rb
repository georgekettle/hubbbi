class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :settings]
  before_action :set_group, only: [:new, :create]

  def show
    @current_user_course_member = @course.course_members.find_by(group_member: current_user.group_members)
    @page = @course.page
    set_breadcrumbs
  end

  def new
    @course = @group.courses.new
    authorize @course
  end

  def create
    @course = @group.courses.new(course_params)
    @course.page = Page.new(title: @course.title)
    @course.course_members.new(group_member: @group.group_members.find_by(user: current_user))
    authorize @course
    if @course.save
      redirect_to course_path(@course), notice: "Course successfully created"
    else
      render :new, status: :unprocessable_entity, alert: "Oops... Something went wrong when creating course"
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: "Your course has successfully been updated"
    else
      render :edit, status: :unprocessable_entity, alert: "Oops... Something went wrong when updating your course"
    end
  end

  def destroy
    if @course.destroy
      redirect_to @course.group, notice: "Course has successfully been destroyed"
    else
      redirect_to settings_course_path(@course), alert: "Oops... Something went wrong when deleting your group"
    end
  end

  def settings
  end

  private

  def set_breadcrumbs
    breadcrumb "All courses", group_path(@course.group)
    breadcrumb @course.title, course_path(@course)
  end

  def course_params
    params.require(:course).permit(:title, :description, :cover)
  end

  def set_course
    @course = Course.find(params[:id])
    authorize @course
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
