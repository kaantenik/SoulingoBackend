class Api::V1::AvatarController < ApplicationController

  def speak
    # Parametreleri al
    text = params[:text]
    avatar_id = params[:avatar_id]

    # Validasyon
    if text.blank?
      return render_error('Text parameter is required', :bad_request)
    end

    if avatar_id.blank?
      return render_error('Avatar ID parameter is required', :bad_request)
    end

    begin
      # HeyGen video oluştur
      video_id = HeygenService.generate_video(text, avatar_id)

      # Video hazır olana kadar bekle
      video_url = HeygenService.wait_until_ready(video_id)

      # Başarılı response döndür
      render_success({
        video_id: video_id,
        video_url: video_url,
        text: text,
        avatar_id: avatar_id
      })

    rescue => e
      Rails.logger.error "HeyGen Avatar Error: #{e.message}"
      render_error("Avatar generation failed: #{e.message}", :internal_server_error)
    end
  end
end
