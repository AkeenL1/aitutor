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

    ai_client = AiClient.new
    sections_and_lessons = ai_client.generate_course(course_params[:title], course_params[:level], params[:user_info],
                                                              params[:additional_info])

    sections_and_lessons.each do |section, lessons|
      section_name = section.to_s
      section = @course.sections.build(title:section_name)
      lessons.each do |lesson|
        lesson_name = lesson.to_s
        section.lessons.build(title:lesson_name, content: "blah")
      end
    end

    if @course.save
      redirect_to courses_path, notice: "Course created successfully."
    else
      render :new
    end
  end

  def show
    @course = Course.find(params[:id])
    @sections = @course.sections
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
