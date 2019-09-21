class CoursesController < ApplicationController
  before_action :verify_authenticity_token
  


  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
  end

  private

  




 
end
