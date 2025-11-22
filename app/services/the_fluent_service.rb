class TheFluentService
  include HTTParty
  base_uri 'https://api.thefluent.ai/v1/public'

  def self.score(audio_url, text, language = "en-US")
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV['THEFLUENT_API_KEY']}"
    }

    body = {
      language: language,
      audioUrl: audio_url,
      text: text
    }.to_json

    response = post('/assessment/score', headers: headers, body: body)

    if response.success?
      response.parsed_response
    else
      raise "TheFluent API Error: #{response.code} - #{response.message}"
    end
  end

  def self.text_to_speech(text, voice_id, language = "en-US")
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV['THEFLUENT_API_KEY']}"
    }

    body = {
      text: text,
      voiceId: voice_id,
      language: language
    }.to_json

    response = post('/tts/synthesize', headers: headers, body: body)

    if response.success?
      response.parsed_response['audioUrl']
    else
      raise "TheFluent TTS API Error: #{response.code} - #{response.message}"
    end
  end
end
