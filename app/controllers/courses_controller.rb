class CoursesController < ApplicationController
  before_action :validate_params, only: [:create]
  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    # hit ai, get list of sections & lessons <--

    ai_client = AiClient.new
    section_titles, lesson_titles = ai_client.generate_course(course_params[:title], course_params[:level], params[:user_info],
                                                              params[:additional_info])

    1.upto(7) do |i|
      section_name = course_params[:title] + "_section#{i}"
      section = @course.sections.build(title: section_name)
      1.upto(4) do |j|
        lesson_name = section_name + "_lesson#{i}"
        section.lessons.build(title: lesson_name, content: "blah")
      end
    end

    if @course.save
      redirect_to courses_path, notice: "Course created successfully."
    else
      render :new
    end
  end

  def destroy
    if Course.find(params[:id]).destroy
      redirect_to courses_path
    end
  end

  private
  def course_params
    params.require(:course).permit(:level, :title)
  end

  def validate_params
    redirect_to courses_path and return unless params[:course][:title].present? && params[:course][:level].present?
    redirect_to courses_path and return unless params[:user_info].present? && params[:additional_info].present?
  end
end
