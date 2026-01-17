# GitHub Actions ile .ipa Oluşturma (Mac Gerektirmez!)

## 🎉 Çözüm: GitHub Actions

GitHub Actions, **ücretsiz Mac runner'ları** sağlar! Böylece Mac'iniz olmadan da .ipa dosyası oluşturabilirsiniz.

## Kurulum Adımları

### 1. GitHub Repository Oluşturun

1. GitHub'da yeni bir repository oluşturun
2. Tüm proje dosyalarını yükleyin:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/KULLANICI_ADI/Sessiz.git
   git push -u origin main
   ```

### 2. GitHub Secrets Ayarlayın

Repository'nizde:
1. **Settings > Secrets and variables > Actions** gidin
2. **New repository secret** ile şu secret'ları ekleyin:

```
FTP_HOST = 147.93.42.246
FTP_USER = u265210178.papayawhip-falcon-938452.hostingersite.com
FTP_PASS = Sa8654210!!
APPLE_TEAM_ID = (Apple Developer Team ID'niz - opsiyonel)
```

### 3. Workflow'u Tetikleyin

1. GitHub repository'nizde **Actions** sekmesine gidin
2. **"Build iOS .ipa"** workflow'unu seçin
3. **"Run workflow"** butonuna tıklayın
4. Workflow çalışacak ve .ipa dosyası oluşturulacak

### 4. .ipa Dosyasını İndirin

1. Workflow tamamlandığında **Artifacts** bölümüne gidin
2. **"Sessiz.ipa"** dosyasını indirin
3. `upload_ipa.php` sayfasından yükleyin

## Otomatik Yükleme

Workflow otomatik olarak .ipa dosyasını FTP sunucunuza yükleyecektir!

## Alternatif: Manuel İndirme

Eğer otomatik yükleme çalışmazsa:
1. Artifacts'tan .ipa dosyasını indirin
2. `upload_ipa.php` sayfasından manuel yükleyin

## Özellikler

- ✅ **Ücretsiz** - GitHub Actions ücretsiz Mac runner sağlar
- ✅ **Otomatik** - Kod push edildiğinde otomatik build
- ✅ **FTP Upload** - Otomatik olarak sunucuya yükler
- ✅ **Artifact** - İndirilebilir .ipa dosyası

## Sorun Giderme

### "Code signing required" Hatası
- Apple Developer hesabı gereklidir
- Secrets'a `APPLE_TEAM_ID` ekleyin
- Veya workflow'u signing olmadan çalıştırın (test için)

### "No scheme found"
- Xcode projesinde scheme'in "Sessiz" olduğundan emin olun
- Veya workflow'daki scheme adını değiştirin

### FTP Upload Hatası
- Secrets'ların doğru olduğundan emin olun
- Manuel olarak Artifacts'tan indirip yükleyin

## Workflow Dosyası

`.github/workflows/build-ipa.yml` dosyası hazır! Sadece GitHub'a push edin.

## Hızlı Başlangıç

```bash
# 1. Git repository oluştur
git init
git add .
git commit -m "Initial commit"

# 2. GitHub'da repository oluştur ve push et
git remote add origin https://github.com/KULLANICI_ADI/Sessiz.git
git push -u origin main

# 3. GitHub'da Actions > Run workflow
# 4. .ipa dosyası oluşturulacak!
```

## Notlar

- GitHub Actions **ücretsiz** Mac runner sağlar (2000 dakika/ay)
- Her build yaklaşık 10-15 dakika sürer
- .ipa dosyası Artifacts'ta 30 gün saklanır
- Otomatik FTP upload ile sunucuya yüklenir

