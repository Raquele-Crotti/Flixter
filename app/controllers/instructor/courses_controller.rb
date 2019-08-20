class Instructor::CoursesController < ApplicationController
  before_action :authenticate_user!

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.create(course_params)
    redirect_to instructor_course_path(@course)
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :cost)
  end
end
