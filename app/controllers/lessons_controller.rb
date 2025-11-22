class LessonsController < ApplicationController
  def index
    lessons = Lesson.all
    render_success(lessons.map { |lesson| lesson_data(lesson) })
  end

  private

  def lesson_data(lesson)
    {
      id: lesson.id,
      title: lesson.title,
      content: lesson.content,
      language: lesson.language,
      created_at: lesson.created_at
    }
  end
end
