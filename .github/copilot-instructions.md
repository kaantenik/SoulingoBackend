# SoulingoBackend - Ruby on Rails API Project

This is a Ruby on Rails API-only backend project for language learning with TheFluent integration.

## Project Structure

### Models
- **User**: Authentication with email/password
- **Lesson**: Language learning content
- **Recording**: User audio recordings
- **Analysis**: Speech analysis results from TheFluent
- **AvatarVoice**: Text-to-speech voice configurations

### Controllers
- **AuthController**: User registration and login with JWT
- **LessonsController**: Lesson management
- **RecordingsController**: Audio recording and analysis
- **VoicesController**: Available TTS voices

### Services
- **TheFluentService**: Integration with TheFluent API for speech scoring and TTS

### Features
- JWT-based authentication
- PostgreSQL database
- CORS enabled for frontend integration
- Hygen code generation templates
- Standardized JSON response format

## Development Guidelines
- No serializers - use direct JSON rendering
- Environment variables for API keys
- RESTful API design
- Proper error handling with consistent JSON format