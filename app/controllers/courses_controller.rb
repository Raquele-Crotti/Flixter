class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
    @enrolled_in = current_user.enrolled_in?(@course)
  end

  private



 
end
