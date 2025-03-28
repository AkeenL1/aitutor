class LessonsController < ApplicationController
  def show
    @lesson = Lesson.find(params[:id])
  end

  def edit
    @lesson = Lesson.find(params[:id])
    ai_client = AiClient.new
    @lesson.content = ai_client.generate_lesson(@lesson.section.course.title, @lesson.section.course.level, @lesson.section.course.goal,
                                 @lesson.section.title,@lesson.title)
    @lesson.save
    redirect_to lesson_path(@lesson)
  end

end