class Api::V1::AnalysisController < ApplicationController
  before_action :authenticate_user
  before_action :set_analysis, only: [:show]

  # POST /api/v1/analysis
  def create
    recording = @current_user.recordings.find(params[:recording_id])

    # Eğer bu recording için zaten analysis varsa, güncelle
    analysis = recording.analysis || recording.build_analysis

    # TheFluent service ile analiz yap
    begin
      analysis_result = TheFluentService.new.analyze_speech(
        audio_url: recording.audio_url,
        reference_text: recording.lesson.content
      )

      analysis.assign_attributes(
        fluency_score: analysis_result[:fluency_score],
        accuracy_score: analysis_result[:accuracy_score],
        completeness_score: analysis_result[:completeness_score],
        prosody_score: analysis_result[:prosody_score],
        overall_score: analysis_result[:overall_score],
        feedback: analysis_result[:feedback]
      )

      if analysis.save
        render json: {
          success: true,
          message: 'Analysis completed successfully',
          analysis: {
            id: analysis.id,
            recording_id: analysis.recording_id,
            fluency_score: analysis.fluency_score,
            accuracy_score: analysis.accuracy_score,
            completeness_score: analysis.completeness_score,
            prosody_score: analysis.prosody_score,
            overall_score: analysis.overall_score,
            feedback: analysis.feedback,
            created_at: analysis.created_at,
            updated_at: analysis.updated_at
          }
        }, status: :created
      else
        render json: {
          success: false,
          error: 'Failed to save analysis',
          details: analysis.errors
        }, status: :unprocessable_entity
      end
    rescue => e
      render json: {
        success: false,
        error: 'Analysis failed',
        details: e.message
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'Recording not found'
    }, status: :not_found
  end

  # GET /api/v1/analysis/:id
  def show
    render json: {
      success: true,
      analysis: {
        id: @analysis.id,
        recording_id: @analysis.recording_id,
        recording: {
          id: @analysis.recording.id,
          lesson_title: @analysis.recording.lesson.title,
          audio_url: @analysis.recording.audio_url,
          transcription: @analysis.recording.transcription
        },
        fluency_score: @analysis.fluency_score,
        accuracy_score: @analysis.accuracy_score,
        completeness_score: @analysis.completeness_score,
        prosody_score: @analysis.prosody_score,
        overall_score: @analysis.overall_score,
        feedback: @analysis.feedback,
        created_at: @analysis.created_at,
        updated_at: @analysis.updated_at
      }
    }
  end

  private

  def set_analysis
    @analysis = Analysis.joins(recording: :user)
                       .where(recordings: { users: { id: @current_user.id } })
                       .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      success: false,
      error: 'Analysis not found'
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
