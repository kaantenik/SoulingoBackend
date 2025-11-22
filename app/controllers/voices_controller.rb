class VoicesController < ApplicationController
  def index
    voices = AvatarVoice.all
    render_success(voices.map { |voice| voice_data(voice) })
  end

  private

  def voice_data(voice)
    {
      id: voice.id,
      provider: voice.provider,
      voice_id: voice.voice_id,
      language: voice.language,
      created_at: voice.created_at
    }
  end
end
