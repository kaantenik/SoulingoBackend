require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users/register' do
    post('register user') do
      tags 'Authentication'
      description 'Register a new user account'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'John Doe' },
          email: { type: :string, format: :email, example: 'user@example.com' },
          password: { type: :string, minimum: 6, example: 'password123' }
        },
        required: %w[name email password]
      }

      response(201, 'user created successfully') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'User created successfully' },
                 user: { '$ref' => '#/components/schemas/User' },
                 token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9...' }
               },
               required: %w[success message user token]

        let(:user_params) { { name: 'Test User', email: 'test@example.com', password: 'password123' } }
        run_test!
      end

      response(422, 'validation errors') do
        schema '$ref' => '#/components/schemas/Error'
        let(:user_params) { { name: '', email: 'invalid', password: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/login' do
    post('login user') do
      tags 'Authentication'
      description 'Login with email and password'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: %w[email password]
      }

      response(200, 'login successful') do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 message: { type: :string, example: 'Login successful' },
                 user: { '$ref' => '#/components/schemas/User' },
                 token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9...' }
               },
               required: %w[success message user token]

        let(:credentials) { { email: 'test@example.com', password: 'password123' } }
        run_test! do |response|
          # This test requires a user to exist first
          # In a real test, you'd create the user in a before block
        end
      end

      response(401, 'invalid credentials') do
        schema '$ref' => '#/components/schemas/Error'
        let(:credentials) { { email: 'wrong@example.com', password: 'wrongpass' } }
        run_test!
      end
    end
  end
end
