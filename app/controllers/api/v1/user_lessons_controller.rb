class Api::V1::UserLessonsController < ApplicationController
  before_action :authenticate_user
  before_action :set_user_lesson, only: [:show]

  # POST /api/v1/user_lessons
  def create
    # UserLesson tablosu yoksa oluştururuz, şimdilik Recording ile simüle edelim
    lesson = Lesson.find(params[:lesson_id])

    # Kullanıcının bu derse kaydolup kaydolmadığını kontrol et
    existing_enrollment = @current_user.recordings.joins(:lesson).where(lessons: { id: lesson.id }).first

    if existing_enrollment
      render json: {
        success: true,
        message: 'Already enrolled in this lesson',
        user_lesson: {
          id: existing_enrollment.id,
          user_id: @current_user.id,
          lesson_id: lesson.id,
          lesson_title: lesson.title,
          enrolled_at: existing_enrollment.created_at
        }
      }
    else
      # Yeni kayıt oluştur (lesson'a başladığını göstermek için boş recording)
      user_lesson = @current_user.recordings.build(lesson: lesson)

      if user_lesson.save
        render json: {
          success: true,
          message: 'Successfully enrolled in lesson',
          user_lesson: {
            id: user_lesson.id,
            user_id: @current_user.id,
            lesson_id: lesson.id,
            lesson_title: lesson.title,
            enrolled_at: user_lesson.created_at
          }
        }, status: :created
      else
        render json: {
          success: false,
          error: 'Failed to enroll in lesson',
          details: user_lesson.errors
        }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'Lesson not found'
    }, status: :not_found
  end

  # GET /api/v1/user_lessons/:id
  def show
    render json: {
      success: true,
      user_lesson: {
        id: @user_lesson.id,
        user_id: @current_user.id,
        lesson_id: @user_lesson.lesson.id,
        lesson_title: @user_lesson.lesson.title,
        lesson_content: @user_lesson.lesson.content,
        lesson_language: @user_lesson.lesson.language,
        lesson_difficulty: @user_lesson.lesson.difficulty,
        enrolled_at: @user_lesson.created_at,
        progress: calculate_progress(@user_lesson)
      }
    }
  end

  private

  def set_user_lesson
    @user_lesson = @current_user.recordings.joins(:lesson).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'User lesson not found'
    }, status: :not_found
  end

  def calculate_progress(user_lesson)
    # Basit progress hesaplama - recording varsa %100, yoksa %0
    user_lesson.audio_url.present? ? 100 : 0
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
