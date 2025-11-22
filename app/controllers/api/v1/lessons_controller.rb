class Api::V1::LessonsController < ApplicationController
  before_action :authenticate_user
  before_action :set_lesson, only: [:show]

  # GET /api/v1/lessons
  def index
    lessons = Lesson.all
    render json: {
      success: true,
      lessons: lessons.map do |lesson|
        {
          id: lesson.id,
          title: lesson.title,
          content: lesson.content,
          language: lesson.language,
          difficulty: lesson.difficulty,
          created_at: lesson.created_at,
          updated_at: lesson.updated_at
        }
      end
    }
  end

  # GET /api/v1/lessons/:id
  def show
    render json: {
      success: true,
      lesson: {
        id: @lesson.id,
        title: @lesson.title,
        content: @lesson.content,
        language: @lesson.language,
        difficulty: @lesson.difficulty,
        created_at: @lesson.created_at,
        updated_at: @lesson.updated_at
      }
    }
  end

  # POST /api/v1/lessons
  def create
    # Parametreleri direkt root'tan al
    lesson_attributes = {
      title: params[:title],
      content: params[:content],
      language: params[:language],
      difficulty: params[:difficulty]
    }

    lesson = Lesson.new(lesson_attributes)

    if lesson.save
      render json: {
        success: true,
        message: 'Lesson created successfully',
        lesson: {
          id: lesson.id,
          title: lesson.title,
          content: lesson.content,
          language: lesson.language,
          difficulty: lesson.difficulty,
          created_at: lesson.created_at,
          updated_at: lesson.updated_at
        }
      }, status: :created
    else
      render json: {
        success: false,
        error: 'Failed to create lesson',
        details: lesson.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'Lesson not found'
    }, status: :not_found
  end

  def lesson_params
    params.require(:lesson).permit(:title, :content, :language, :difficulty)
  end

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = JWT.decode(header, Rails.application.secret_key_base)[0]
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError
      render json: { success: false, error: 'Unauthorized' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { success: false, error: 'User not found' }, status: :unauthorized
    end
  end
end
