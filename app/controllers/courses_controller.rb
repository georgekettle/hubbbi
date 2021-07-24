class CoursesController < ApplicationController
  before_action :set_course, only: :show

  def show
  end

  private

  def set_course
    @course = Course.find(params[:id])
    authorize @course
  end
end
