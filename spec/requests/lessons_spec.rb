require 'swagger_helper'

RSpec.describe 'api/v1/lessons', type: :request do
  path '/api/v1/lessons' do
    get('list lessons') do
      tags 'Lessons'
      description 'Get all available lessons'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'

      response(200, 'lessons retrieved successfully') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 lessons: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Lesson' }
                 }
               },
               required: %w[success lessons]

        run_test!
      end

      response(401, 'unauthorized') do
        schema '$ref' => '#/components/schemas/Error'
        run_test!
      end
    end

    post('create lesson') do
      tags 'Lessons'
      description 'Create a new lesson'
      consumes 'application/json'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'
      parameter name: :lesson_params, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'Basic Greetings' },
          content: { type: :string, example: 'Hello, how are you?' },
          language: { type: :string, example: 'English' },
          difficulty: { type: :string, enum: %w[beginner intermediate advanced], example: 'beginner' }
        },
        required: %w[title content language difficulty]
      }

      response(201, 'lesson created successfully') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'Lesson created successfully' },
                 lesson: { '$ref' => '#/components/schemas/Lesson' }
               },
               required: %w[success message lesson]

        let(:lesson_params) { { title: 'Test Lesson', content: 'Hello world', language: 'English', difficulty: 'beginner' } }
        run_test!
      end

      response(422, 'validation errors') do
        schema '$ref' => '#/components/schemas/Error'
        let(:lesson_params) { { title: '', content: '', language: '', difficulty: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/lessons/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show lesson') do
      tags 'Lessons'
      description 'Get a specific lesson'
      produces 'application/json'
      security [Bearer: []]

      parameter name: :Authorization, in: :header, type: :string, required: false,
                description: 'Bearer token for authentication'

      response(200, 'lesson found') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 lesson: { '$ref' => '#/components/schemas/Lesson' }
               },
               required: %w[success lesson]

        let(:id) { '1' }
        run_test!
      end

      response(404, 'lesson not found') do
        schema '$ref' => '#/components/schemas/Error'
        let(:id) { '999' }
        run_test!
      end
    end
  end
end
