# SoulingoBackend - Ruby on Rails API

Bu proje, dil öğrenimi için Ruby on Rails API-only backend uygulamasıdır. TheFluent entegrasyonu ile konuşma analizi ve text-to-speech özelliklerini içerir.

## Özellikler

- **JWT Authentication**: Kullanıcı kayıt ve giriş sistemi
- **Lesson Management**: Dil öğrenme içerikleri
- **Speech Recording**: Ses kayıtları ve analiz
- **TheFluent Integration**: Konuşma skorlama ve TTS
- **API-Only**: Serializer kullanmadan direkt JSON response
- **CORS Support**: Frontend entegrasyonu için CORS desteği
- **HeyGen Integration**: Konuşan avatar video oluşturma

## Kurulum

### Gereksinimler
- Ruby 3.3.3
- Rails 7.1.x
- SQLite3

### Kurulum Adımları

1. **Depoyu klonlayın**
   ```bash
   git clone <repo-url>
   cd SoulingoBackend
   ```

2. **Gem'leri yükleyin**
   ```bash
   bundle install
   ```

3. **Environment variables ayarlayın**
   ```bash
   cp .env.example .env
   # .env dosyasını düzenleyin ve API KEY'lerini ekleyin
   ```

4. **Veritabanını hazırlayın**
   ```bash
   rails db:create db:migrate db:seed
   ```

5. **Sunucuyu başlatın**
   ```bash
   rails server
   ```

## API Endpoints

### Authentication
- `POST /register` - Kullanıcı kaydı
- `POST /login` - Kullanıcı girişi

### Lessons
- `GET /lessons` - Tüm dersleri listele

### Recordings
- `POST /recordings` - Yeni ses kaydı oluştur
- `GET /recordings/:id` - Ses kaydını görüntüle
- `POST /recordings/:id/analyze` - Ses kaydını analiz et

### Voices
- `GET /voices` - Mevcut TTS seslerini listele

### HeyGen Avatar
- `POST /api/v1/avatar/speak` - Konuşan avatar videosu oluştur

## JSON Response Format

### Başarılı Response
```json
{
  "success": true,
  "data": { ... }
}
```

### Hatalı Response
```json
{
  "success": false,
  "error": "error message"
}
```

## Modeller

### User
- `email:string` - Unique email
- `name:string` - Kullanıcı adı
- `password_digest:string` - Şifrelenmiş parola

### Lesson
- `title:string` - Ders başlığı
- `content:text` - Ders içeriği
- `language:string` - Dil kodu (en-US, tr-TR, vs.)

### Recording
- `user:references` - Kullanıcı referansı
- `lesson:references` - Ders referansı
- `audio_url:string` - Ses dosyası URL'i
- `status:string` - Durum (pending, analyzed)

### Analysis
- `recording:references` - Kayıt referansı
- `fluency_score:float` - Akıcılık skoru
- `accuracy_score:float` - Doğruluk skoru
- `overall_score:float` - Genel skor
- `feedback:text` - Geri bildirim

### AvatarVoice
- `provider:string` - Sağlayıcı (default: "thefluent")
- `voice_id:string` - Ses ID'si
- `language:string` - Dil kodu

## API Integrations

### TheFluent Integration

### Scoring API
```ruby
TheFluentService.score(audio_url, text, language = "en-US")
```

### Text-to-Speech API
```ruby
TheFluentService.text_to_speech(text, voice_id, language = "en-US")
```

### HeyGen Integration

#### Avatar Video Generation
```ruby
HeygenService.generate_video(text, avatar_id)
```

#### Video Status Check
```ruby
HeygenService.check_status(video_id)
```

#### Wait Until Ready
```ruby
HeygenService.wait_until_ready(video_id)
```

## Development

### Tests
```bash
rails test
```

### Console
```bash
rails console
```

### Database Console
```bash
rails dbconsole
```

## Environment Variables

- `THEFLUENT_API_KEY` - TheFluent API anahtarı
- `HEYGEN_API_KEY` - HeyGen API anahtarı

