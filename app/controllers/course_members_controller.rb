class CourseMembersController < ApplicationController
  before_action :set_course, only: [:new, :create]
  before_action :hide_navbar, only: [:new]

  def index
    @course = Course.find(params[:course_id])
    @course_members = @course.course_members
  end

  def new
    @invite = Invite.new
    @invite.sub_invites.build
  end

  def create
    add_participants if params[:course_member][:id]
    if @course.save
      redirect_to course_course_members_path(@course), notice: "Participants successfully added to course"
    else
      render :new, alert: "Oops... Something went wrong when adding participants"
    end
  end

  def update
    @course_member = CourseMember.find(params[:id])
    authorize @course_member.group_member, :update?
    respond_to do |format|
      if @course_member.update(course_member_params)
        format.html { redirect_back fallback_location: reorder_course_members_path, notice: "#{@course_member.user.full_name_or_email} was successfully updated" }
        format.json { render json: @course_member }
      else
        format.html { redirect_back fallback_location: reorder_course_members_path, alert: "Oops, there was an error updating user #{@course_member.user.full_name_or_email}" }
        format.json { render json: @course_member }
      end
    end
  end

  def destroy
    @course_member = CourseMember.find(params[:id])
    authorize @course_member
    @course_member.destroy
    if @course_member.user == current_user
      redirect_to group_path(@course_member.group), notice: "You successfully removed yourself from #{@course_member.course.title.capitalize}"
    else
      redirect_back fallback_location: course_course_members_path(@course_member.course), notice: "#{@course_member.user.full_name_or_email} was successfully removed from the course"
    end
  end

  def reorder
    @course_members = Current.group_member.course_members
    authorize Current.group_member, :update?
  end

  private

  def add_participants
    params[:course_member][:id].delete_at(0) # remove first value (as always empty)
    group_member_ids = params[:course_member][:id]
    group_member_ids.each do |id|
      @course.course_members.new(group_member: GroupMember.find(id)) if GroupMember.find(id)
    end
  end

  def set_course
    @course = Course.find(params[:course_id])
    authorize @course
  end

  def course_member_params
    params.require(:course_member).permit(:position)
  end
end
