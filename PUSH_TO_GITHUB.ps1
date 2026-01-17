# GitHub'a Dosyaları Push Etme Scripti

Write-Host "🚀 GitHub'a dosyaları push ediliyor..." -ForegroundColor Green

# Proje klasörüne git
$projectPath = "C:\Users\GRAND SAPPHİRE IT\Desktop\Sessiz"
Set-Location $projectPath

Write-Host "📁 Klasör: $projectPath" -ForegroundColor Cyan

# Git repository kontrolü
if (-not (Test-Path ".git")) {
    Write-Host "⚠️  Git repository bulunamadı. Initialize ediliyor..." -ForegroundColor Yellow
    git init
}

# .gitignore kontrolü
Write-Host "📝 .gitignore kontrol ediliyor..." -ForegroundColor Cyan
if (Test-Path ".gitignore") {
    $gitignoreContent = Get-Content ".gitignore" -Raw
    if ($gitignoreContent -match "^\*\.swift$") {
        Write-Host "⚠️  .gitignore'da *.swift ignore edilmiş. Düzeltiliyor..." -ForegroundColor Yellow
        (Get-Content ".gitignore") -replace "^\*\.swift$", "# *.swift  # Swift kaynak dosyalarını commit etmeliyiz!" | Set-Content ".gitignore"
    }
}

# Dosyaları ekle
Write-Host "📦 Dosyalar ekleniyor..." -ForegroundColor Cyan
git add .

# Durumu göster
Write-Host "`n📊 Git durumu:" -ForegroundColor Cyan
git status --short

# Commit yap
Write-Host "`n💾 Commit yapılıyor..." -ForegroundColor Cyan
git commit -m "Add iOS project files for GitHub Actions build"

# Remote kontrolü
Write-Host "`n🔗 Remote repository kontrol ediliyor..." -ForegroundColor Cyan
$remote = git remote -v
if (-not $remote) {
    Write-Host "⚠️  Remote repository bulunamadı!" -ForegroundColor Yellow
    Write-Host "Lütfen şu komutu çalıştırın:" -ForegroundColor Yellow
    Write-Host "git remote add origin <GITHUB_REPO_URL>" -ForegroundColor White
    exit
}

# Push yap
Write-Host "`n⬆️  GitHub'a push ediliyor..." -ForegroundColor Cyan
$branch = git branch --show-current
if (-not $branch) {
    $branch = "master"
}

Write-Host "Branch: $branch" -ForegroundColor Cyan
git push -u origin $branch

Write-Host "`n✅ Tamamlandı!" -ForegroundColor Green
Write-Host "GitHub Actions'da workflow'u çalıştırabilirsiniz." -ForegroundColor Green

