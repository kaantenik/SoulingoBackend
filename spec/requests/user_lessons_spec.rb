require 'swagger_helper'

RSpec.describe 'api/v1/user_lessons', type: :request do
  path '/api/v1/user_lessons' do
    post('enroll in lesson') do
      tags 'User Lessons'
      description 'Enroll user in a lesson'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'
      parameter name: :enrollment_params, in: :body, schema: {
        type: :object,
        properties: {
          lesson_id: { type: :integer, example: 1 }
        },
        required: %w[lesson_id]
      }

      response(201, 'successfully enrolled') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'Successfully enrolled in lesson' },
                 user_lesson: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     user_id: { type: :integer },
                     lesson_id: { type: :integer },
                     lesson_title: { type: :string },
                     enrolled_at: { type: :string, format: 'date-time' }
                   }
                 }
               },
               required: %w[success message user_lesson]

        let(:enrollment_params) { { lesson_id: 1 } }
        run_test!
      end

      response(404, 'lesson not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:enrollment_params) { { lesson_id: 999 } }
        run_test!
      end
    end
  end

  path '/api/v1/user_lessons/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show user lesson') do
      tags 'User Lessons'
      description 'Get user lesson details with progress'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'

      response(200, 'user lesson found') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 user_lesson: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     user_id: { type: :integer },
                     lesson_id: { type: :integer },
                     lesson_title: { type: :string },
                     lesson_content: { type: :string },
                     lesson_language: { type: :string },
                     lesson_difficulty: { type: :string },
                     enrolled_at: { type: :string, format: 'date-time' },
                     progress: { type: :integer, example: 75, description: 'Progress percentage (0-100)' }
                   }
                 }
               },
               required: %w[success user_lesson]

        let(:id) { '1' }
        run_test!
      end

      response(404, 'user lesson not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:id) { '999' }
        run_test!
      end
    end
  end
end
