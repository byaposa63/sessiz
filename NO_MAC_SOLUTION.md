# Mac Olmadan .ipa Oluşturma Çözümleri

## 🎯 En İyi Çözüm: GitHub Actions

GitHub Actions **ücretsiz Mac runner'ları** sağlar! Mac'iniz olmadan da .ipa oluşturabilirsiniz.

### Avantajlar:
- ✅ **Ücretsiz** - Ayda 2000 dakika ücretsiz
- ✅ **Otomatik** - Kod push edildiğinde otomatik build
- ✅ **FTP Upload** - Otomatik olarak sunucuya yükler
- ✅ **Kolay** - Sadece GitHub'a push edin

### Adımlar:

1. **GitHub Repository Oluşturun**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/KULLANICI/Sessiz.git
   git push -u origin main
   ```

2. **GitHub Secrets Ayarlayın**
   - Settings > Secrets > Actions
   - FTP bilgilerini ekleyin

3. **Workflow'u Çalıştırın**
   - Actions > Build iOS .ipa > Run workflow

4. **.ipa Dosyasını İndirin**
   - Artifacts'tan indirin
   - Veya otomatik FTP upload ile sunucuya yüklenir

## Alternatif Çözümler

### 1. Cloud Build Servisleri

**Bitrise** (Ücretsiz plan):
- https://www.bitrise.io
- Mac runner sağlar
- Otomatik .ipa oluşturur

**AppCircle** (Ücretsiz plan):
- https://appcircle.io
- CI/CD servisi
- .ipa oluşturur

**Codemagic** (Sınırlı ücretsiz):
- https://codemagic.io
- Flutter/iOS build

### 2. Mac Bulut Servisleri

**MacStadium** (Ücretli):
- Bulut Mac kiralama
- Xcode ile .ipa oluşturma

**MacinCloud** (Ücretli):
- Uzaktan Mac erişimi
- Xcode kullanımı

### 3. GitHub Actions (Önerilen)

**Neden GitHub Actions?**
- ✅ Tamamen ücretsiz
- ✅ Kolay kurulum
- ✅ Otomatik build
- ✅ FTP upload desteği

**Kurulum:**
1. `.github/workflows/build-ipa.yml` dosyası hazır
2. GitHub'a push edin
3. Actions'tan çalıştırın
4. .ipa dosyası hazır!

## Hızlı Başlangıç (GitHub Actions)

```bash
# 1. Repository hazırla
./setup_github.sh

# 2. GitHub'da repository oluştur
# 3. Push et
git remote add origin https://github.com/KULLANICI/Sessiz.git
git push -u origin main

# 4. GitHub'da:
#    - Settings > Secrets > Actions
#    - FTP bilgilerini ekle
#    - Actions > Run workflow
```

## Workflow Dosyası

`.github/workflows/build-ipa.yml` dosyası hazır ve şunları yapar:

1. ✅ Mac runner'da Xcode kurulumu
2. ✅ Projeyi derleme
3. ✅ Archive oluşturma
4. ✅ .ipa export
5. ✅ FTP ile otomatik yükleme
6. ✅ Artifact olarak indirilebilir yapma

## Sorun Giderme

### "No signing certificate"
- Apple Developer hesabı gereklidir
- Veya signing olmadan build (sadece test)

### "Scheme not found"
- Xcode projesinde scheme adını kontrol edin
- Workflow'daki scheme adını güncelleyin

### FTP Upload Hatası
- Secrets'ları kontrol edin
- Manuel olarak Artifacts'tan indirin

## Özet

**En Kolay Yol:**
1. GitHub'a push edin
2. Actions'tan çalıştırın
3. .ipa dosyası hazır!

**Mac Gerektirmez!** 🎉

