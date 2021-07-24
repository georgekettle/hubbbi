class CourseMembersController < ApplicationController

  def index
    @course = Course.find(params[:course_id])
    @course_members = @course.course_members
  end
end
