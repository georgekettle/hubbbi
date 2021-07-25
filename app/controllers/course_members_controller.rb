class CourseMembersController < ApplicationController
  before_action :set_course, only: [:new, :create]
  before_action :hide_navbar, only: [:new]

  def index
    @course = Course.find(params[:course_id])
    @course_members = @course.course_members
  end

  def new
  end

  def create
    add_participants if params[:course_member][:id]
    if @course.save
      redirect_to course_course_members_path(@course), notice: "Participants successfully added to course"
    else
      render :new, alert: "Oops... Something went wrong when adding participants"
    end
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
end
