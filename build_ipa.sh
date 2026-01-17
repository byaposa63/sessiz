#!/bin/bash

# iOS .ipa Dosyası Oluşturma Script'i
# Bu script Xcode'da .ipa dosyasını oluşturmanıza yardımcı olur

echo "🚀 Sessiz iOS Uygulaması - .ipa Oluşturma"
echo "=========================================="
echo ""

# Xcode projesi kontrolü
if [ ! -d "Sessiz.xcodeproj" ]; then
    echo "❌ Hata: Sessiz.xcodeproj bulunamadı!"
    echo "Bu script'i proje kök dizininde çalıştırın."
    exit 1
fi

echo "✅ Xcode projesi bulundu"
echo ""

# Xcode versiyonu kontrolü
echo "📱 Xcode Bilgileri:"
xcodebuild -version
echo ""

# Workspace kontrolü
SCHEME="Sessiz"
CONFIGURATION="Release"
ARCHIVE_PATH="./build/Sessiz.xcarchive"
EXPORT_PATH="./build/export"
IPA_PATH="./build/Sessiz.ipa"

echo "📦 Archive Oluşturuluyor..."
echo ""

# Archive oluştur
xcodebuild archive \
    -project Sessiz.xcodeproj \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    -destination "generic/platform=iOS" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

if [ $? -ne 0 ]; then
    echo "❌ Archive oluşturulamadı!"
    echo ""
    echo "Manuel olarak yapmanız gerekenler:"
    echo "1. Xcode'u açın"
    echo "2. Product > Destination > Any iOS Device seçin"
    echo "3. Product > Archive (⌘B sonra Archive)"
    echo "4. Organizer'da 'Distribute App' butonuna tıklayın"
    echo "5. 'Ad Hoc' veya 'Development' seçin"
    echo "6. .ipa dosyasını export edin"
    exit 1
fi

echo "✅ Archive oluşturuldu: $ARCHIVE_PATH"
echo ""

# Export Options plist oluştur
EXPORT_OPTIONS_PLIST="./build/ExportOptions.plist"
cat > "$EXPORT_OPTIONS_PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>ad-hoc</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
</dict>
</plist>
EOF

echo "📦 IPA Export Ediliyor..."
echo ""

# IPA export et
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "$EXPORT_OPTIONS_PLIST"

if [ $? -ne 0 ]; then
    echo "❌ IPA export edilemedi!"
    echo ""
    echo "Manuel olarak yapmanız gerekenler:"
    echo "1. Xcode Organizer'ı açın (Window > Organizer)"
    echo "2. Archive'inizi seçin"
    echo "3. 'Distribute App' butonuna tıklayın"
    echo "4. 'Ad Hoc' seçin"
    echo "5. Sertifikanızı seçin"
    echo "6. Export edin"
    exit 1
fi

# IPA dosyasını bul ve kopyala
FOUND_IPA=$(find "$EXPORT_PATH" -name "*.ipa" | head -1)

if [ -z "$FOUND_IPA" ]; then
    echo "❌ IPA dosyası bulunamadı!"
    exit 1
fi

# IPA dosyasını web/uploads/app/ klasörüne kopyala
WEB_UPLOAD_DIR="./web/uploads/app"
mkdir -p "$WEB_UPLOAD_DIR"

cp "$FOUND_IPA" "$WEB_UPLOAD_DIR/Sessiz.ipa"

echo "✅ IPA dosyası oluşturuldu!"
echo "📁 Konum: $WEB_UPLOAD_DIR/Sessiz.ipa"
echo "📊 Boyut: $(du -h "$WEB_UPLOAD_DIR/Sessiz.ipa" | cut -f1)"
echo ""
echo "🎉 Başarılı! Şimdi upload_ipa.php sayfasından yükleyebilirsiniz."
echo "   veya FTP ile web/uploads/app/Sessiz.ipa dosyasını yükleyin."

