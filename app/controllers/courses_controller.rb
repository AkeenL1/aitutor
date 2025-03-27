class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    # hit ai, get list of sections & lessons <--
    # create sections with
    #  # for each section you'd store the lesson titles
    # TODO: replace with actual hits to openai and for each section

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

  private
  def course_params
    params.require(:course).permit(:level, :title)
  end

end
