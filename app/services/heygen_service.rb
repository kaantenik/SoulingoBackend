require 'net/http'
require 'json'

class HeygenService
  BASE_URL = 'https://api.heygen.com'

  def self.generate_video(text, avatar_id)
    uri = URI("#{BASE_URL}/v2/video/generate")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['x-api-key'] = ENV['HEYGEN_API_KEY']
    request['Content-Type'] = 'application/json'

    body = {
      video_inputs: [{
        character: {
          type: "avatar",
          avatar_id: avatar_id
        },
        voice: {
          type: "text",
          input_text: text
        }
      }],
      aspect_ratio: "16:9",
      test: false
    }

    request.body = body.to_json

    response = http.request(request)

    if response.code == '200'
      result = JSON.parse(response.body)
      return result['data']['video_id']
    else
      raise "HeyGen API Error: #{response.code} - #{response.body}"
    end
  end

  def self.check_status(video_id)
    uri = URI("#{BASE_URL}/v1/video_status.get?video_id=#{video_id}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['x-api-key'] = ENV['HEYGEN_API_KEY']

    response = http.request(request)

    if response.code == '200'
      result = JSON.parse(response.body)
      return {
        status: result['data']['status'],
        video_url: result['data']['video_url']
      }
    else
      raise "HeyGen Status API Error: #{response.code} - #{response.body}"
    end
  end

  def self.wait_until_ready(video_id, max_attempts = 60)
    attempts = 0

    while attempts < max_attempts
      status_data = check_status(video_id)

      case status_data[:status]
      when 'completed'
        return status_data[:video_url]
      when 'failed'
        raise "Video generation failed for video_id: #{video_id}"
      when 'processing', 'pending'
        sleep(3) # 3 saniye bekle
        attempts += 1
      else
        raise "Unknown status: #{status_data[:status]}"
      end
    end

    raise "Video generation timeout for video_id: #{video_id}"
  end
end
