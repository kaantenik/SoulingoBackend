require 'swagger_helper'

RSpec.describe 'api/v1/analysis', type: :request do
  path '/api/v1/analysis' do
    post('create analysis') do
      tags 'Analysis'
      description 'Analyze a recording for speech quality using TheFluent API'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'
      parameter name: :analysis_params, in: :body, schema: {
        type: :object,
        properties: {
          recording_id: { type: :integer, example: 1 }
        },
        required: %w[recording_id]
      }

      response(201, 'analysis completed successfully') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'Analysis completed successfully' },
                 analysis: { '$ref' => '#/components/schemas/Analysis' }
               },
               required: %w[success message analysis]

        let(:analysis_params) { { recording_id: 1 } }
        run_test!
      end

      response(404, 'recording not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:analysis_params) { { recording_id: 999 } }
        run_test!
      end

      response(422, 'analysis failed') do
        schema '$ref' => '#/components/schemas/Error'
        let(:analysis_params) { { recording_id: 1 } }
        run_test!
      end
    end
  end

  path '/api/v1/analysis/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show analysis') do
      tags 'Analysis'
      description 'Get analysis results with recording details'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'

      response(200, 'analysis found') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 analysis: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     recording_id: { type: :integer },
                     recording: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         lesson_title: { type: :string },
                         audio_url: { type: :string },
                         transcription: { type: :string }
                       }
                     },
                     fluency_score: { type: :number, format: :float },
                     accuracy_score: { type: :number, format: :float },
                     completeness_score: { type: :number, format: :float },
                     prosody_score: { type: :number, format: :float },
                     overall_score: { type: :number, format: :float },
                     feedback: { type: :string },
                     created_at: { type: :string, format: 'date-time' },
                     updated_at: { type: :string, format: 'date-time' }
                   }
                 }
               },
               required: %w[success analysis]

        let(:id) { '1' }
        run_test!
      end

      response(404, 'analysis not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:id) { '999' }
        run_test!
      end
    end
  end
end
