module GroupMembers
  class CourseMembersController < ApplicationController
    before_action :set_group_member, only: [:new, :create]

    def new
      @group = @group_member.group
      @courses = @group.courses - @group_member.courses
      @course_member = CourseMember.new
      hide_navbar
    end

    def create
      update_user_courses if params[:course_member][:id]
      redirect_back fallback_location: @group_member, notice: "User successfully added to courses"
    end

    private

    def set_group_member
      @group_member = GroupMember.find(params[:group_member_id])
      authorize @group_member, :create?
    end

    def update_user_courses
      course_ids = params[:course_member][:id]
      course_ids.delete("") # remove empty value
      course_ids.each do |id|
        course = Course.find(id)
        @group_member.course_members.create(course: course) unless @group_member.courses.include?(course)
      end
    end
  end
end
