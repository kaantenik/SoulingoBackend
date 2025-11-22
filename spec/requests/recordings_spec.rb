require 'swagger_helper'

RSpec.describe 'api/v1/recordings', type: :request do
  path '/api/v1/recordings' do
    post('create recording') do
      tags 'Recordings'
      description 'Create a new audio recording'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'
      parameter name: :lesson_id, in: :formData, type: :integer, required: true,
                description: 'ID of the lesson this recording belongs to'
      parameter name: :audio_file, in: :formData, type: :file, required: true,
                description: 'Audio file to upload'

      response(201, 'recording created successfully') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'Recording created successfully' },
                 recording: { '$ref' => '#/components/schemas/Recording' }
               },
               required: %w[success message recording]

        let(:lesson_id) { 1 }
        let(:audio_file) { fixture_file_upload('test_audio.wav', 'audio/wav') }
        run_test!
      end

      response(422, 'validation errors') do
        schema '$ref' => '#/components/schemas/Error'
        let(:lesson_id) { nil }
        let(:audio_file) { nil }
        run_test!
      end
    end
  end

  path '/api/v1/recordings/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show recording') do
      tags 'Recordings'
      description 'Get a specific recording'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'

      response(200, 'recording found') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 recording: { '$ref' => '#/components/schemas/Recording' }
               },
               required: %w[success recording]

        let(:id) { '1' }
        run_test!
      end

      response(404, 'recording not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:id) { '999' }
        run_test!
      end
    end
  end
end
