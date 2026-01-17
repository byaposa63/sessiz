# Xcode Proje Kurulumu ve .ipa Oluşturma

## Hızlı Başlangıç

### 1. Xcode'u Açın

```bash
# Mac'te Terminal'den
open Sessiz.xcodeproj
```

Veya Finder'dan `Sessiz.xcodeproj` dosyasına çift tıklayın.

### 2. Proje Ayarları

#### Signing & Capabilities

1. Sol panelde **"Sessiz"** projesine tıklayın
2. **"Signing & Capabilities"** sekmesine gidin
3. **"Automatically manage signing"** işaretleyin
4. **Team** olarak Apple Developer hesabınızı seçin
5. **Bundle Identifier** benzersiz olmalı (örn: `com.yourcompany.sessiz`)

#### Background Modes

1. **"+ Capability"** butonuna tıklayın
2. **"Background Modes"** ekleyin
3. Şunları işaretleyin:
   - ✅ Location updates
   - ✅ Audio, AirPlay, and Picture in Picture
   - ✅ Background processing

### 3. Archive Oluşturma

1. Üst kısımda device seçiciden **"Any iOS Device"** seçin
2. Menüden: **Product > Archive**
3. Derleme başlayacak (5-10 dakika sürebilir)
4. Organizer penceresi otomatik açılacak

### 4. .ipa Export

1. Organizer'da archive'inizi seçin
2. **"Distribute App"** butonuna tıklayın
3. **"Ad Hoc"** seçin
4. **"Next"** > **"Export"**
5. Desktop'a kaydedin

### 5. Sunucuya Yükleme

1. `upload_ipa.php` sayfasını açın
2. Desktop'taki .ipa dosyasını yükleyin
3. ✅ Tamamlandı!

## Gerekli Dosyalar

Projede şu dosyalar mevcut:
- ✅ `AppDelegate.swift`
- ✅ `LocationManager.swift`
- ✅ `AudioRecorder.swift`
- ✅ `DataUploader.swift`
- ✅ `ViewController.swift`
- ✅ `Info.plist`

## Önemli Notlar

1. **Apple Developer Hesabı Gerekli:**
   - Ücretsiz hesap ile test edebilirsiniz
   - Ad Hoc dağıtım için cihaz UDID'si gerekir

2. **Cihaz Kaydı:**
   - Ad Hoc dağıtım için cihazınızın UDID'sini Apple Developer'a eklemeniz gerekir
   - Xcode > Window > Devices and Simulators'den UDID'yi görebilirsiniz

3. **TestFlight Alternatifi:**
   - App Store Connect üzerinden TestFlight kullanabilirsiniz
   - Bu daha kolay ve cihaz kaydı gerektirmez

## Hata Çözümleri

### "Code signing is required"
- Signing & Capabilities'de Apple Developer hesabınızı seçin
- "Automatically manage signing" işaretleyin

### "No devices registered"
- Apple Developer hesabınıza cihazınızı ekleyin
- Xcode otomatik olarak ekleyebilir (ilk kez bağladığınızda)

### Archive oluşturulamıyor
- Simulator yerine "Any iOS Device" seçin
- Tüm build hatalarını düzeltin

## Sonraki Adımlar

1. ✅ .ipa dosyasını oluşturun
2. ✅ `upload_ipa.php` ile yükleyin
3. ✅ `app-install.php` sayfasından test edin
4. ✅ iOS cihazınıza kurun

