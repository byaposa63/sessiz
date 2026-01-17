# 🚀 Mac Olmadan .ipa Oluşturma - Hızlı Başlangıç

## ⚡ 5 Dakikada .ipa Oluşturun!

### Adım 1: GitHub Repository Oluşturun (2 dk)

1. https://github.com/new adresine gidin
2. Repository adı: `Sessiz` (veya istediğiniz)
3. **Create repository** butonuna tıklayın
4. Repository URL'ini kopyalayın (örn: `https://github.com/kullanici/Sessiz.git`)

### Adım 2: Projeyi GitHub'a Push Edin (1 dk)

Windows PowerShell'de:

```powershell
cd C:\Users\GRAND SAPPHİRE IT\Desktop\Sessiz

# Git kurulu değilse: https://git-scm.com/download/win

git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/KULLANICI_ADI/Sessiz.git
git push -u origin main
```

**Not:** GitHub kullanıcı adı ve şifreniz istenecek.

### Adım 3: GitHub Secrets Ayarlayın (1 dk)

1. GitHub repository'nizde **Settings** sekmesine gidin
2. Sol menüden **Secrets and variables > Actions** seçin
3. **New repository secret** butonuna tıklayın
4. Şu secret'ları ekleyin:

```
Name: FTP_HOST
Value: 147.93.42.246

Name: FTP_USER  
Value: u265210178.papayawhip-falcon-938452.hostingersite.com

Name: FTP_PASS
Value: Sa8654210!!
```

### Adım 4: Workflow'u Çalıştırın (1 dk)

1. GitHub repository'nizde **Actions** sekmesine gidin
2. Sol menüden **"Build iOS .ipa"** workflow'unu seçin
3. **"Run workflow"** butonuna tıklayın
4. **"Run workflow"** butonuna tekrar tıklayın

### Adım 5: .ipa Dosyasını Bekleyin (10-15 dk)

1. Workflow çalışmaya başlayacak
2. Yaklaşık 10-15 dakika sürecek
3. Tamamlandığında yeşil tik görünecek
4. **Artifacts** bölümünde **"Sessiz.ipa"** dosyasını göreceksiniz

### Adım 6: .ipa Dosyasını İndirin

**Yöntem 1: Otomatik (FTP)**
- Workflow otomatik olarak sunucuya yükleyecek
- `app-install.php` sayfasından kontrol edin

**Yöntem 2: Manuel**
1. Artifacts bölümünde **"Sessiz.ipa"** dosyasına tıklayın
2. İndirin
3. `upload_ipa.php` sayfasından yükleyin

## ✅ Tamamlandı!

Artık .ipa dosyanız hazır! Mac gerektirmedi! 🎉

## Sorun mu Var?

### "Workflow not found"
- `.github/workflows/build-ipa.yml` dosyasının GitHub'da olduğundan emin olun
- Dosyayı tekrar push edin

### "Build failed"
- Xcode proje yapısını kontrol edin
- Scheme adının "Sessiz" olduğundan emin olun

### "FTP upload failed"
- Secrets'ları kontrol edin
- Manuel olarak Artifacts'tan indirin

## Tekrar Build İçin

Kod değişikliği yaptığınızda:
1. Değişiklikleri commit edin
2. GitHub'a push edin
3. Actions'tan workflow'u tekrar çalıştırın
4. Yeni .ipa dosyası oluşturulacak

## Özet

```
GitHub'a Push → Actions Çalıştır → .ipa Hazır!
```

**Mac Gerektirmez!** GitHub Actions ücretsiz Mac runner sağlar! 🚀

