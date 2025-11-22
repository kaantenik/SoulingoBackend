require 'swagger_helper'

RSpec.describe 'api/v1/avatar', type: :request do
  path '/api/v1/avatar/speak' do
    post('avatar speak') do
      tags 'Avatar'
      description 'Generate avatar speech using HeyGen API'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :speak_params, in: :body, schema: {
        type: :object,
        properties: {
          text: { type: :string, example: 'Hello, welcome to Soulingo!' },
          voice_id: { type: :string, example: 'voice_123' },
          avatar_id: { type: :string, example: 'avatar_456' }
        },
        required: %w[text voice_id]
      }

      response(200, 'avatar speech generated successfully') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'Avatar speech generated successfully' },
                 video_url: { type: :string, format: :url, example: 'https://example.com/video.mp4' },
                 audio_url: { type: :string, format: :url, example: 'https://example.com/audio.mp3' }
               },
               required: %w[success message]

        let(:speak_params) { { text: 'Hello world', voice_id: 'voice_123' } }
        run_test!
      end

      response(422, 'validation errors') do
        schema '$ref' => '#/components/schemas/Error'
        let(:speak_params) { { text: '', voice_id: '' } }
        run_test!
      end

      response(500, 'HeyGen API error') do
        schema '$ref' => '#/components/schemas/Error'
        let(:speak_params) { { text: 'Hello world', voice_id: 'invalid_voice' } }
        run_test!
      end
    end
  end
end
