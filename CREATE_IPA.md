# .ipa Dosyası Oluşturma Kılavuzu

## ⚠️ Önemli Not

.ipa dosyası **Xcode ile derlenmiş bir binary dosyasıdır** ve otomatik olarak oluşturulamaz. Aşağıdaki adımları **Mac bilgisayarınızda Xcode ile** yapmanız gerekmektedir.

## Adım 1: Xcode'da Projeyi Hazırlama

### 1.1 Projeyi Açın

1. Mac'inizde Xcode'u açın
2. `File > Open` ile `Sessiz.xcodeproj` dosyasını açın
3. Proje yüklenecek

### 1.2 Signing & Capabilities Ayarları

1. Sol panelde proje adına tıklayın
2. "Signing & Capabilities" sekmesine gidin
3. "Automatically manage signing" işaretleyin
4. Apple Developer hesabınızı seçin
5. Bundle Identifier'ı benzersiz yapın (örn: `com.yourcompany.sessiz`)

### 1.3 Capabilities Ekleme

1. "+ Capability" butonuna tıklayın
2. Şunları ekleyin:
   - ✅ Background Modes
     - Location updates
     - Audio, AirPlay, and Picture in Picture
   - ✅ Push Notifications (opsiyonel)

## Adım 2: Archive Oluşturma

### 2.1 Device Seçimi

1. Xcode'un üst kısmında device seçiciden **"Any iOS Device"** seçin
   - Simulator seçmeyin, gerçek cihaz veya "Any iOS Device" olmalı

### 2.2 Archive

1. Menüden: **Product > Archive**
   - Veya: `⌘B` (Build) sonra **Product > Archive**
2. Derleme başlayacak (birkaç dakika sürebilir)
3. Derleme tamamlandığında **Organizer** penceresi otomatik açılacak

## Adım 3: .ipa Dosyasını Export Etme

### 3.1 Organizer'da

1. Organizer penceresinde oluşturduğunuz archive'i seçin
2. **"Distribute App"** butonuna tıklayın

### 3.2 Distribution Method Seçimi

1. **"Ad Hoc"** seçin (test için)
   - Veya **"Development"** (sadece kayıtlı cihazlar için)
   - Veya **"App Store Connect"** (App Store için)
2. **"Next"** butonuna tıklayın

### 3.3 Sertifika ve Provisioning Profile

1. Otomatik imzalama seçeneğini seçin
2. Sertifikanızı seçin
3. **"Next"** butonuna tıklayın

### 3.4 Export

1. Export seçeneklerini kontrol edin
2. **"Export"** butonuna tıklayın
3. Kayıt konumunu seçin (örn: Desktop)
4. **"Export"** butonuna tıklayın
5. .ipa dosyası seçtiğiniz konuma kaydedilecek

## Adım 4: .ipa Dosyasını Sunucuya Yükleme

### Yöntem 1: Web Arayüzü (Önerilen)

1. Tarayıcıda `upload_ipa.php` sayfasını açın
2. Oluşturduğunuz .ipa dosyasını seçin
3. "Dosyayı Yükle" butonuna tıklayın
4. Dosya `uploads/app/Sessiz.ipa` olarak kaydedilecek

### Yöntem 2: FTP ile

1. FTP ile `public_html/uploads/app/` klasörüne gidin
2. .ipa dosyasını `Sessiz.ipa` olarak yükleyin

## Adım 5: Test Etme

1. `app-install.php` sayfasına gidin
2. "Uygulamayı İndir" butonunun göründüğünü kontrol edin
3. iOS cihazınızda Safari ile açın
4. İndirme linkine tıklayın
5. Kurulum talimatlarını takip edin

## Sorun Giderme

### "No signing certificate found"
- Apple Developer hesabınızın aktif olduğundan emin olun
- Xcode > Preferences > Accounts'tan hesabınızı ekleyin

### "Provisioning profile not found"
- Xcode'da "Automatically manage signing" seçeneğini kullanın
- Veya manuel olarak provisioning profile oluşturun

### Archive oluşturulamıyor
- "Any iOS Device" seçili olduğundan emin olun
- Simulator seçiliyse Archive oluşturulamaz
- Tüm hataları düzeltin (kırmızı işaretler)

### .ipa dosyası çok büyük
- Normal: 50-200MB arası olabilir
- Maksimum: 500MB (sunucu limiti)

## Hızlı Komut (Terminal)

Eğer Mac'inizde Terminal kullanıyorsanız:

```bash
# Proje dizinine gidin
cd /path/to/Sessiz

# Build script'ini çalıştırın (eğer hazırsa)
chmod +x build_ipa.sh
./build_ipa.sh
```

**Not:** Bu script tam otomatik çalışmayabilir, çünkü Apple Developer hesabı ve sertifikalar gerektirir. En güvenilir yöntem Xcode GUI kullanmaktır.

## Özet

1. ✅ Xcode'da projeyi açın
2. ✅ Signing ayarlarını yapın
3. ✅ Product > Archive
4. ✅ Distribute App > Ad Hoc
5. ✅ Export edin
6. ✅ `upload_ipa.php` ile yükleyin

**Önemli:** .ipa dosyası binary bir dosyadır ve sadece Mac + Xcode ile oluşturulabilir. Ben bu dosyayı otomatik oluşturamam, ancak size adım adım talimatlar verebilirim.

