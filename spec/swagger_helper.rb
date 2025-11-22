# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-specs gem, this will be the same
  # folder that contains your spec files.
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Soulingo Backend API V1',
        version: 'v1',
        description: 'API documentation for Soulingo language learning platform'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Development server'
        }
      ],
      components: {
        schemas: {
          User: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              name: { type: 'string' },
              email: { type: 'string', format: 'email' },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            },
            required: %w[id name email]
          },
          Lesson: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              title: { type: 'string' },
              content: { type: 'string' },
              language: { type: 'string' },
              difficulty: { type: 'string', enum: %w[beginner intermediate advanced] },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            },
            required: %w[id title content language difficulty]
          },
          Recording: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              user_id: { type: 'integer' },
              lesson_id: { type: 'integer' },
              audio_url: { type: 'string', format: 'url' },
              transcription: { type: 'string' },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            },
            required: %w[id user_id lesson_id]
          },
          Analysis: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              recording_id: { type: 'integer' },
              fluency_score: { type: 'number', format: 'float' },
              accuracy_score: { type: 'number', format: 'float' },
              completeness_score: { type: 'number', format: 'float' },
              prosody_score: { type: 'number', format: 'float' },
              overall_score: { type: 'number', format: 'float' },
              feedback: { type: 'string' },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            },
            required: %w[id recording_id overall_score]
          },
          AvatarVoice: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              name: { type: 'string' },
              voice_id: { type: 'string' },
              language: { type: 'string' },
              gender: { type: 'string', enum: %w[male female] },
              accent: { type: 'string' },
              is_active: { type: 'boolean' },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            },
            required: %w[id name voice_id language gender]
          },
          Error: {
            type: 'object',
            properties: {
              success: { type: 'boolean', example: false },
              error: { type: 'string' },
              details: { type: 'object' }
            },
            required: %w[success error]
          }
        },
        securitySchemes: {
          Bearer: {
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT'
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename, format and
  # the output folder for the generated Swagger files.
  config.openapi_format = :yaml
end
