module GroupMembers
  class CourseMembersController < ApplicationController
    include Groupable

    before_action :set_group_member, only: [:new, :create]

    def new
      @group = @group_member.group
      @course_member = CourseMember.new
      set_selected_group(@group)
      hide_navbar
    end

    def create
      update_user_courses if params[:course_member][:id]
      redirect_back fallback_location: @group_member, notice: "User successfully added/removed from courses"
    end

    private

    def set_group_member
      @group_member = GroupMember.find(params[:group_member_id])
      authorize @group_member, :create?
    end

    def update_user_courses
      params[:course_member][:id].delete_at(0) # remove first value (as always empty)
      course_ids = params[:course_member][:id]
      selected_courses = []
      course_ids.each do |id|
        course = Course.find(id)
        selected_courses << course
        # if not a course member -> create course member
        @group_member.course_members.create(course: course) unless @group_member.courses.include?(course)
        # if already a course member -> do nothing
      end
      # if current course member not included -> destroy it
      remove_courses_not_included(selected_courses)
    end

    def remove_courses_not_included(selected_courses)
      @group_member.course_members.each do |member|
        member.destroy unless selected_courses.include?(member.course)
      end
    end
  end
end
