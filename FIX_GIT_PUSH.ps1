# Git Push Sorunu Düzeltme Scripti

Write-Host "🔧 Git push sorunu düzeltiliyor..." -ForegroundColor Green

# Ana klasöre git
$projectPath = "C:\Users\GRAND SAPPHİRE IT\Desktop\Sessiz"
Set-Location $projectPath

Write-Host "📁 Klasör: $projectPath" -ForegroundColor Cyan

# Git init (eğer yoksa)
if (-not (Test-Path ".git")) {
    Write-Host "📦 Git repository initialize ediliyor..." -ForegroundColor Cyan
    git init
} else {
    Write-Host "✅ Git repository zaten mevcut" -ForegroundColor Green
}

# Remote repository kontrolü
Write-Host "`n🔗 Remote repository kontrol ediliyor..." -ForegroundColor Cyan
$remote = git remote -v 2>$null

if ($remote) {
    Write-Host "Mevcut remote:" -ForegroundColor Yellow
    Write-Host $remote -ForegroundColor Gray
    
    $update = Read-Host "Remote'u güncellemek ister misiniz? (y/n)"
    if ($update -eq "y" -or $update -eq "Y") {
        git remote set-url origin https://github.com/byaposa63/sessiz.git
        Write-Host "✅ Remote güncellendi" -ForegroundColor Green
    }
} else {
    Write-Host "Remote ekleniyor..." -ForegroundColor Cyan
    git remote add origin https://github.com/byaposa63/sessiz.git
    Write-Host "✅ Remote eklendi" -ForegroundColor Green
}

# Dosyaları ekle
Write-Host "`n📦 Dosyalar ekleniyor..." -ForegroundColor Cyan
git add .

# Durumu göster
Write-Host "`n📊 Git durumu:" -ForegroundColor Cyan
git status --short

# Commit kontrolü
$hasChanges = git diff --cached --quiet
if (-not $hasChanges) {
    Write-Host "`n💾 Commit yapılıyor..." -ForegroundColor Cyan
    git commit -m "Add iOS project files for GitHub Actions"
    Write-Host "✅ Commit tamamlandı" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Commit edilecek değişiklik yok" -ForegroundColor Yellow
}

# Credentials uyarısı
Write-Host "`n⚠️  ÖNEMLİ: Push yaparken GitHub size kullanıcı adı ve şifre soracak" -ForegroundColor Yellow
Write-Host "   Username: byaposa63" -ForegroundColor White
Write-Host "   Password: GitHub Personal Access Token (şifre değil!)" -ForegroundColor White
Write-Host "`n   Token oluşturmak için:" -ForegroundColor Cyan
Write-Host "   GitHub → Settings → Developer settings → Personal access tokens" -ForegroundColor Gray

# Push yap
Write-Host "`n⬆️  GitHub'a push ediliyor..." -ForegroundColor Cyan
$branch = git branch --show-current
if (-not $branch) {
    $branch = "master"
}

Write-Host "Branch: $branch" -ForegroundColor Cyan

try {
    git push -u origin $branch
    Write-Host "`n✅ Push başarılı!" -ForegroundColor Green
} catch {
    Write-Host "`n❌ Push başarısız!" -ForegroundColor Red
    Write-Host "Hata: $_" -ForegroundColor Red
    Write-Host "`nÇözüm:" -ForegroundColor Yellow
    Write-Host "1. GitHub Personal Access Token oluşturun" -ForegroundColor White
    Write-Host "2. Push yaparken şifre yerine token kullanın" -ForegroundColor White
}

