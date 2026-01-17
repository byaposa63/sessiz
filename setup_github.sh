#!/bin/bash

# GitHub Repository Kurulum Script'i
# Bu script GitHub repository'nizi hazırlar

echo "🚀 GitHub Repository Kurulumu"
echo "=============================="
echo ""

# Git kontrolü
if ! command -v git &> /dev/null; then
    echo "❌ Git yüklü değil!"
    echo "Git'i yükleyin: https://git-scm.com/downloads"
    exit 1
fi

echo "✅ Git bulundu: $(git --version)"
echo ""

# Repository kontrolü
if [ -d ".git" ]; then
    echo "ℹ️  Git repository zaten mevcut"
else
    echo "📦 Git repository oluşturuluyor..."
    git init
    echo "✅ Repository oluşturuldu"
fi

# .gitignore kontrolü
if [ ! -f ".gitignore" ]; then
    echo "📝 .gitignore oluşturuluyor..."
    cat > .gitignore << 'EOF'
# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
*.xcworkspace
xcuserdata/
*.xcuserstate

# Build
build/
DerivedData/
*.ipa
*.dSYM

# Python
__pycache__/
*.pyc
venv/

# Node
node_modules/
package-lock.json

# IDE
.idea/
.vscode/

# OS
.DS_Store
Thumbs.db

# Sensitive
web/config.php
web/uploads/app/*.ipa
web/uploads/audio/*.m4a
EOF
    echo "✅ .gitignore oluşturuldu"
fi

# Dosyaları ekle
echo "📁 Dosyalar ekleniyor..."
git add .
echo "✅ Dosyalar eklendi"
echo ""

# Commit
echo "💾 Commit oluşturuluyor..."
git commit -m "Initial commit: Sessiz iOS App"
echo "✅ Commit oluşturuldu"
echo ""

echo "═══════════════════════════════════════"
echo "📋 Sonraki Adımlar:"
echo "═══════════════════════════════════════"
echo ""
echo "1. GitHub'da yeni repository oluşturun:"
echo "   https://github.com/new"
echo ""
echo "2. Repository URL'ini kopyalayın"
echo ""
echo "3. Şu komutu çalıştırın:"
echo "   git remote add origin https://github.com/KULLANICI_ADI/Sessiz.git"
echo "   git push -u origin main"
echo ""
echo "4. GitHub'da Settings > Secrets > Actions'a gidin"
echo "   Şu secret'ları ekleyin:"
echo "   - FTP_HOST = 147.93.42.246"
echo "   - FTP_USER = u265210178.papayawhip-falcon-938452.hostingersite.com"
echo "   - FTP_PASS = Sa8654210!!"
echo ""
echo "5. Actions > Build iOS .ipa > Run workflow"
echo ""
echo "✅ .ipa dosyası otomatik oluşturulacak!"
echo ""

