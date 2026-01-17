# Git Push Sorunu Düzeltme

## Sorun
1. ❌ `web` klasöründe git init yapılmış (yanlış klasör)
2. ❌ `FiberYazilim` kullanıcı adıyla push yapılmaya çalışılıyor (yanlış hesap)
3. ✅ Repository: `byaposa63/sessiz.git`

## Çözüm

### Adım 1: Ana Klasöre Git

```powershell
cd "C:\Users\GRAND SAPPHİRE IT\Desktop\Sessiz"
```

### Adım 2: Git Credentials'ı Temizle

```powershell
# Windows Credential Manager'dan eski credentials'ı sil
git credential-manager-core erase
# veya
git credential reject
```

Sonra şunu çalıştırın:
```powershell
git config --global credential.helper manager-core
```

### Adım 3: Ana Klasörde Git Init

```powershell
# Ana klasörde git init yap
cd "C:\Users\GRAND SAPPHİRE IT\Desktop\Sessiz"
git init
```

### Adım 4: Remote Repository Ekle

```powershell
# Eğer remote yoksa ekle
git remote add origin https://github.com/byaposa63/sessiz.git

# Veya mevcut remote'u değiştir
git remote set-url origin https://github.com/byaposa63/sessiz.git
```

### Adım 5: Dosyaları Ekle ve Commit

```powershell
# Tüm dosyaları ekle
git add .

# Commit yap
git commit -m "Add iOS project files for GitHub Actions"
```

### Adım 6: Doğru Kullanıcı ile Push

```powershell
# Push yap (GitHub sizden kullanıcı adı ve şifre/token isteyecek)
git push -u origin master
```

**Önemli:** GitHub size kullanıcı adı ve şifre sorduğunda:
- **Username:** `byaposa63`
- **Password:** GitHub Personal Access Token (şifre değil!)

### Personal Access Token Oluşturma

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. "Generate new token" → "Generate new token (classic)"
3. İsim verin: "Sessiz Project"
4. Scopes: `repo` seçin
5. "Generate token" → Token'ı kopyalayın
6. Push yaparken şifre yerine bu token'ı kullanın

## Alternatif: SSH Kullan

```powershell
# SSH key oluştur (eğer yoksa)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Public key'i GitHub'a ekle
# GitHub → Settings → SSH and GPG keys → New SSH key

# Remote'u SSH ile değiştir
git remote set-url origin git@github.com:byaposa63/sessiz.git

# Push yap
git push -u origin master
```

