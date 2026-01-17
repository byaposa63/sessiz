# Sessiz - iOS Ebeveyn Kontrolü Uygulaması

iOS uygulaması ve PHP/HTML web dashboard'u içeren kapsamlı ebeveyn kontrolü sistemi.

## Özellikler

### iOS Uygulaması
- 📍 **Konum Takibi**: Sürekli konum güncellemeleri ve arka plan takibi
- 🎤 **Ortam Dinleme**: Mikrofon kayıtları ve ses kaydetme
- ☁️ **Uzaktan Erişim**: Tüm veriler sunucuya yüklenir

### Web Dashboard
- 📊 **Dashboard**: Cihazlar, konumlar ve ses kayıtları için genel bakış
- 🗺️ **Harita Görüntüleme**: Google Maps ile konum takibi
- 📈 **İstatistikler**: Aktivite grafikleri ve detaylı raporlar
- 🎧 **Ses Oynatıcı**: Yüklenen ses kayıtlarını dinleme

## Kurulum

### iOS Uygulaması

1. Xcode'da projeyi açın
2. Bundle Identifier'ı değiştirin
3. `Info.plist` dosyasındaki izin açıklamalarını özelleştirin
4. `DataUploader.swift` dosyasındaki `serverURL` değeri zaten ayarlanmış (gerekirse güncelleyin)

### Web Dashboard

1. `web/` klasöründeki dosyaları FTP ile sunucuya yükleyin
2. `web/database.sql` dosyasını phpMyAdmin'de çalıştırın
3. `web/config.php` dosyasını kontrol edin (veritabanı bilgileri zaten ayarlanmış)
4. `web/uploads/audio/` klasörüne yazma izni verin
5. Detaylı kurulum için `web/INSTALL.md` dosyasına bakın

## Önemli Notlar

### iOS Sınırlamaları

1. **Arka Plan Çalışma**: iOS, arka planda çalışan uygulamaları sınırlar. Konum takibi için "Always" izni gereklidir.

2. **Mikrofon Erişimi**: Arka planda mikrofon kullanımı sınırlıdır. iOS, arka planda uzun süreli ses kaydını otomatik olarak durdurabilir.

3. **Bildirimler**: iOS, konum izinleri için kullanıcıya bildirim gösterebilir. Bu tamamen engellenemez.

4. **Pil Tüketimi**: Sürekli konum takibi ve ses kaydı pil tüketimini artırır.

### Yasal Uyarı

- Bu uygulama yalnızca yasal amaçlarla kullanılmalıdır
- Kullanıcıdan açık izin alınmalıdır
- Yerel yasalara uygun olmalıdır
- Gizlilik yasalarına dikkat edilmelidir

## Yapılandırma

### Sunucu Entegrasyonu

`DataUploader.swift` dosyasında sunucu URL'inizi ayarlayın:

```swift
private let serverURL = "https://your-server.com/api/upload"
```

Sunucunuz şu formatta veri almalıdır:

**Konum Verisi:**
```json
{
  "device_id": "unique-device-id",
  "type": "location",
  "latitude": 41.0082,
  "longitude": 28.9784,
  "timestamp": 1234567890,
  "accuracy": 10.5,
  "speed": 0.0,
  "course": 0.0
}
```

**Ses Verisi:**
```json
{
  "device_id": "unique-device-id",
  "type": "audio",
  "filename": "recording_1234567890.m4a",
  "audio_data": "base64-encoded-audio",
  "timestamp": 1234567890
}
```

## Kullanım

1. Uygulamayı cihaza yükleyin
2. İlk açılışta konum ve mikrofon izinlerini verin
3. Uygulama otomatik olarak çalışmaya başlar
4. Veriler otomatik olarak sunucuya yüklenir

## Sorun Giderme

### Konum Takibi Çalışmıyor
- Ayarlar > Gizlilik > Konum Servisleri'nden izinleri kontrol edin
- "Her Zaman" izninin verildiğinden emin olun

### Ses Kaydı Çalışmıyor
- Ayarlar > Gizlilik > Mikrofon'dan izinleri kontrol edin
- Arka plan uygulama yenileme ayarlarını kontrol edin

### Veriler Yüklenmiyor
- İnternet bağlantısını kontrol edin
- Sunucu URL'inin doğru olduğundan emin olun
- Bekleyen veriler `pending_uploads.json` dosyasında saklanır

