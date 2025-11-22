class RecordingsController < ApplicationController
  def create
    recording = current_user.recordings.build(recording_params)

    if recording.save
      render_success(recording_data(recording))
    else
      render_error(recording.errors.full_messages.join(', '))
    end
  end

  def show
    recording = current_user.recordings.find(params[:id])
    render_success(recording_data_with_analysis(recording))
  rescue ActiveRecord::RecordNotFound
    render_error('Recording not found', :not_found)
  end

  def analyze
    recording = current_user.recordings.find(params[:id])
    expected_text = recording.lesson.content

    begin
      result = TheFluentService.score(recording.audio_url, expected_text)

      analysis = recording.create_analysis(
        fluency_score: result['fluencyScore'],
        accuracy_score: result['accuracyScore'],
        overall_score: result['overallScore'],
        feedback: result['feedback']
      )

      recording.update(status: 'analyzed')

      render_success({
        analysis_id: analysis.id,
        result: result,
        recording: recording_data_with_analysis(recording)
      })
    rescue => e
      render_error("Analysis failed: #{e.message}")
    end
  rescue ActiveRecord::RecordNotFound
    render_error('Recording not found', :not_found)
  end

  private

  def recording_params
    params.require(:recording).permit(:lesson_id, :audio_url)
  end

  def recording_data(recording)
    {
      id: recording.id,
      user_id: recording.user_id,
      lesson_id: recording.lesson_id,
      audio_url: recording.audio_url,
      status: recording.status,
      created_at: recording.created_at
    }
  end

  def recording_data_with_analysis(recording)
    data = recording_data(recording)
    if recording.analysis
      data[:analysis] = {
        id: recording.analysis.id,
        fluency_score: recording.analysis.fluency_score,
        accuracy_score: recording.analysis.accuracy_score,
        overall_score: recording.analysis.overall_score,
        feedback: recording.analysis.feedback
      }
    end
    data
  end
end
