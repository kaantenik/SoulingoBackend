# Swagger UI Kullanım Kılavuzu

Soulingo Backend API'si artık Swagger UI ile dokümante edilmiştir. Bu kılavuz size API'yi nasıl görüntüleyeceğinizi ve test edeceğinizi gösterir.

## Swagger UI'ya Erişim

1. Rails server'ınızın çalıştığından emin olun:
   ```bash
   bundle exec rails server
   ```

2. Tarayıcınızda şu URL'ye gidin:
   ```
   http://localhost:3000/api-docs
   ```

## Mevcut Endpoint'ler

### 📌 Users (Kullanıcı Yönetimi)
- **POST /api/v1/users/register** - Yeni kullanıcı kaydı
- **POST /api/v1/users/login** - Kullanıcı girişi

### 📌 Lessons (Ders Yönetimi)
- **GET /api/v1/lessons** - Tüm dersleri listele (JWT token gerekli)
- **GET /api/v1/lessons/{id}** - Belirli bir dersi görüntüle (JWT token gerekli)
- **POST /api/v1/lessons** - Yeni ders oluştur (JWT token gerekli)

### 📌 User Lessons (Ders Kaydı)
- **POST /api/v1/user_lessons** - Derse kayıt ol (JWT token gerekli)
- **GET /api/v1/user_lessons/{id}** - Ders kaydı detayları ve ilerleme (JWT token gerekli)

### 📌 Recordings (Ses Kayıtları)
- **POST /api/v1/recordings** - Yeni ses kaydı oluştur (JWT token gerekli)
- **GET /api/v1/recordings/{id}** - Belirli bir kaydı görüntüle (JWT token gerekli)

### 📌 Analysis (Konuşma Analizi)
- **POST /api/v1/analysis** - Ses kaydını analiz et (JWT token gerekli)
- **GET /api/v1/analysis/{id}** - Analiz sonuçlarını görüntüle (JWT token gerekli)

### 📌 Avatar (HeyGen Entegrasyonu)
- **POST /api/v1/avatar/speak** - HeyGen API ile avatar konuşması oluştur

### Legacy Endpoints (Geriye Uyumluluk)
- **POST /register** - ⚠️ Deprecated: /api/v1/users/register kullanın
- **POST /login** - ⚠️ Deprecated: /api/v1/users/login kullanın
- **GET /lessons** - ⚠️ Deprecated: /api/v1/lessons kullanın
- **POST /recordings** - ⚠️ Deprecated: /api/v1/recordings kullanın
- **GET /recordings/{id}** - ⚠️ Deprecated: /api/v1/recordings/{id} kullanın
- **POST /recordings/{id}/analyze** - ⚠️ Deprecated: /api/v1/analysis kullanın
- **GET /voices** - Mevcut TTS seslerini listele

## API Test Etme

### 1. Kullanıcı Kaydı ve Girişi
1. Swagger UI'da **Authentication** sekmesini açın
2. **POST /register** endpoint'ini genişletin
3. "Try it out" butonuna tıklayın
4. Email ve password bilgilerini girin
5. "Execute" butonuna tıklayın
6. Dönen JWT token'ı kopyalayın

### 2. JWT Token ile API'leri Test Etme
1. Swagger UI sayfasının üst kısmındaki "Authorize" butonuna tıklayın
2. "Bearer" alanına `Bearer YOUR_JWT_TOKEN` formatında token'ı girin
3. "Authorize" butonuna tıklayın
4. Artık korumalı endpoint'leri test edebilirsiniz

### 3. Dosya Yükleme (Recordings)
1. **POST /recordings** endpoint'ini açın
2. "Try it out" butonuna tıklayın
3. lesson_id parametresini girin
4. audio_file için bir ses dosyası seçin
5. "Execute" butonuna tıklayın

## Swagger Dokümantasyonunu Güncelleme

API'de değişiklik yaptığınızda Swagger dokümantasyonunu güncellemek için:

```bash
bundle exec rake rswag:specs:swaggerize
```

## Model Şemaları

Swagger UI'da aşağıdaki modeller tanımlanmıştır:
- **User**: Kullanıcı bilgileri
- **Lesson**: Ders bilgileri
- **Recording**: Ses kaydı bilgileri
- **Analysis**: Analiz sonuçları
- **AvatarVoice**: TTS ses konfigürasyonları
- **Error**: Hata mesajları

## JWT Authentication

Korumalı endpoint'ler için JWT token gereklidir. Token'ı şu şekilde kullanın:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

## Geliştirici Notları

- Swagger spec dosyaları `spec/requests/` dizininde bulunur
- Swagger konfigürasyonu `spec/swagger_helper.rb` dosyasında yapılır
- Oluşturulan YAML dosyası `swagger/v1/swagger.yaml` konumundadır
- UI konfigürasyonu `config/initializers/rswag_ui.rb` dosyasındadır