require 'swagger_helper'

RSpec.describe 'voices', type: :request do
  path '/voices' do
    get('list voices') do
      tags 'Voices'
      description 'Get all available text-to-speech voices'
      produces 'application/json'

      response(200, 'voices retrieved successfully') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 voices: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/AvatarVoice' }
                 }
               },
               required: %w[success voices]

        run_test!
      end
    end
  end
end
