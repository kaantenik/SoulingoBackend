# SoulingoBackend Postman Collection

Bu klasör SoulingoBackend API'si için Postman collection ve environment dosyalarını içerir.

## Dosyalar

- `SoulingoBackend.postman_collection.json` - Ana Postman collection
- `SoulingoBackend.postman_environment.json` - Local development environment

## Kurulum

1. **Postman'ı açın**
2. **Import** butonuna tıklayın
3. **Collection dosyasını** seçin: `SoulingoBackend.postman_collection.json`
4. **Environment dosyasını** seçin: `SoulingoBackend.postman_environment.json`
5. **Sağ üst köşeden** "SoulingoBackend Local" environment'ını seçin

## Kullanım

### 1. Authentication Flow
1. **"Register User"** isteğini çalıştırın
2. JWT token otomatik olarak environment'a kaydedilecek
3. Tüm diğer istekler bu token'ı kullanacak

### 2. Test Senaryoları

Collection otomatik test script'leri içerir:

- ✅ **Response status** kontrolü
- ✅ **JWT token** otomatik kaydetme
- ✅ **ID'leri** otomatik environment'a kaydetme
- ✅ **Response format** doğrulama

### 3. Environment Variables

- `base_url`: API base URL (http://localhost:3000)
- `jwt_token`: Authentication token (otomatik doldurulur)
- `lesson_id`: Oluşturulan lesson ID'si
- `recording_id`: Oluşturulan recording ID'si
- `analysis_id`: Oluşturulan analysis ID'si

## Endpoint'ler

### 🔐 Authentication
- `POST /api/v1/users/register` - Kullanıcı kaydı
- `POST /api/v1/users/login` - Kullanıcı girişi

### 📚 Lessons
- `GET /api/v1/lessons` - Tüm dersleri listele
- `GET /api/v1/lessons/{id}` - Ders detayı
- `POST /api/v1/lessons` - Yeni ders oluştur

### 👤 User Lessons
- `POST /api/v1/user_lessons` - Derse kayıt ol
- `GET /api/v1/user_lessons/{id}` - Kayıt durumu ve ilerleme

### 🎤 Recordings
- `POST /api/v1/recordings` - Ses kaydı oluştur
- `GET /api/v1/recordings/{id}` - Kayıt detayı

### 📊 Analysis
- `POST /api/v1/analysis` - Konuşma analizi
- `GET /api/v1/analysis/{id}` - Analiz sonuçları

### 🤖 Avatar
- `POST /api/v1/avatar/speak` - Avatar konuşması oluştur

### 🔊 Voices
- `GET /voices` - Mevcut TTS sesleri

## Test Çalıştırma

Collection'ı **Collection Runner** ile çalıştırabilirsiniz:
1. Collection'a sağ tıklayın
2. **"Run collection"** seçin
3. Tüm testler otomatik olarak çalışacak

## Notlar

- Tüm korumalı endpoint'ler JWT authentication gerektirir
- Token'lar otomatik olarak yönetilir
- Environment variables istekler arasında paylaşılır
- Test script'leri başarı durumunda ID'leri otomatik kaydeder