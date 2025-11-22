class Api::V1::RecordingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_recording, only: [:show]

  # POST /api/v1/recordings
  def create
    lesson = Lesson.find(params[:lesson_id])
    recording = @current_user.recordings.build(lesson: lesson)

    if params[:audio_file].present?
      # Gerçek implementasyonda dosya yükleme logic'i buraya gelecek
      recording.audio_url = "recordings/#{SecureRandom.uuid}.wav"
      recording.transcription = params[:transcription] if params[:transcription].present?
    end

    if recording.save
      render json: {
        success: true,
        message: 'Recording created successfully',
        recording: {
          id: recording.id,
          user_id: recording.user_id,
          lesson_id: recording.lesson_id,
          audio_url: recording.audio_url,
          transcription: recording.transcription,
          created_at: recording.created_at,
          updated_at: recording.updated_at
        }
      }, status: :created
    else
      render json: {
        success: false,
        error: 'Failed to create recording',
        details: recording.errors
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'Lesson not found'
    }, status: :not_found
  end

  # GET /api/v1/recordings/:id
  def show
    render json: {
      success: true,
      recording: {
        id: @recording.id,
        user_id: @recording.user_id,
        lesson_id: @recording.lesson_id,
        lesson_title: @recording.lesson.title,
        audio_url: @recording.audio_url,
        transcription: @recording.transcription,
        created_at: @recording.created_at,
        updated_at: @recording.updated_at,
        analysis: @recording.analysis ? {
          id: @recording.analysis.id,
          fluency_score: @recording.analysis.fluency_score,
          accuracy_score: @recording.analysis.accuracy_score,
          completeness_score: @recording.analysis.completeness_score,
          prosody_score: @recording.analysis.prosody_score,
          overall_score: @recording.analysis.overall_score,
          feedback: @recording.analysis.feedback
        } : nil
      }
    }
  end

  private

  def set_recording
    @recording = @current_user.recordings.includes(:lesson, :analysis).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'Recording not found'
    }, status: :not_found
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
