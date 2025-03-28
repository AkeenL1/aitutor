class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    ai_client = AiClient.new
    user_info = " I am a computer science graduate with an ok understanding of core cs fundamentals.
Currently I work as a backend software engineer for about 2 years.My goal is  to gain a deeper understanding of #{course_params[:title].downcase}
from a first principles perspective and gain a better understanding of #{course_params[:title].downcase} for my job as a backend engineer"
    sections_and_lessons = ai_client.generate_course(course_params[:title], course_params[:level], user_info,
                                                     "I prefer to do projects where possible")
    @course = Course.new(title: course_params[:title], level: course_params[:level], goal: user_info)
    sections_and_lessons.each do |section, lessons|
      section_name = section.to_s
      section = @course.sections.build(title:section_name)
      lessons.each do |lesson|
        lesson_name = lesson.to_s
        section.lessons.build(title:lesson_name, content: nil)
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
end
