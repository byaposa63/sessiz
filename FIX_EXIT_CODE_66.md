# Exit Code 66 Hatası Düzeltme

## Sorun
Exit code 66 genellikle Xcode build hatalarından kaynaklanır:
- Scheme bulunamıyor
- Proje yapısı eksik
- Signing sorunları
- Dosya yolları yanlış

## Çözüm 1: Debug Workflow Kullanın

GitHub'da `blank.yml` dosyasını şununla değiştirin:

```yaml
name: Build iOS .ipa (Debug)

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Xcode
      uses: maxim-lobanov/setup-xcode@v1
      with:
        xcode-version: latest-stable
    
    - name: Debug - Show environment
      run: |
        echo "🔍 Xcode versiyonu:"
        xcodebuild -version
        echo ""
        echo "🔍 Mevcut dizin:"
        pwd
        echo ""
        echo "🔍 Dosya yapısı:"
        ls -la
    
    - name: Debug - Check Xcode project
      run: |
        if [ -d "Sessiz.xcodeproj" ]; then
          echo "✅ Xcode projesi bulundu"
        else
          echo "❌ Xcode projesi bulunamadı!"
          find . -name "*.xcodeproj" | head -10
          exit 1
        fi
    
    - name: Debug - List schemes
      run: |
        echo "📋 Scheme'ler:"
        xcodebuild -list -project Sessiz.xcodeproj 2>&1
    
    - name: Build Archive
      run: |
        xcodebuild clean archive \
          -project Sessiz.xcodeproj \
          -scheme Sessiz \
          -configuration Release \
          -archivePath ./build/Sessiz.xcarchive \
          -destination "generic/platform=iOS" \
          CODE_SIGN_IDENTITY="" \
          CODE_SIGNING_REQUIRED=NO \
          CODE_SIGNING_ALLOWED=NO \
          2>&1 | tee build.log
        BUILD_STATUS=${PIPESTATUS[0]}
        if [ $BUILD_STATUS -ne 0 ]; then
          echo "❌ Build başarısız! Exit code: $BUILD_STATUS"
          tail -100 build.log
          exit $BUILD_STATUS
        fi
    
    - name: Create Export Options
      if: success()
      run: |
        mkdir -p build
        cat > build/ExportOptions.plist << 'EOF'
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>method</key>
            <string>ad-hoc</string>
        </dict>
        </plist>
        EOF
    
    - name: Export IPA
      if: success()
      run: |
        xcodebuild -exportArchive \
          -archivePath ./build/Sessiz.xcarchive \
          -exportPath ./build/export \
          -exportOptionsPlist ./build/ExportOptions.plist \
          CODE_SIGN_IDENTITY="" \
          CODE_SIGNING_REQUIRED=NO
    
    - name: Find and Upload IPA
      if: success()
      run: |
        IPA_FILE=$(find ./build/export -name "*.ipa" 2>/dev/null | head -1)
        if [ -z "$IPA_FILE" ]; then
          echo "❌ IPA bulunamadı!"
          ls -la ./build/export/ || true
          exit 1
        fi
        echo "✅ IPA: $IPA_FILE"
    
    - name: Upload IPA artifact
      if: success()
      uses: actions/upload-artifact@v4
      with:
        name: Sessiz.ipa
        path: build/export/*.ipa
        retention-days: 30
```

## Çözüm 2: Proje Yapısını Kontrol Edin

Workflow çalıştıktan sonra "Debug - List schemes" adımının çıktısını kontrol edin:

1. **Scheme adı yanlışsa:** Workflow'daki `-scheme Sessiz` kısmını doğru scheme adıyla değiştirin
2. **Proje bulunamıyorsa:** Dosyaların GitHub'a push edildiğinden emin olun

## Çözüm 3: Basit Build (Test)

Önce basit bir build deneyin:

```yaml
- name: Simple Build Test
  run: |
    xcodebuild -project Sessiz.xcodeproj \
      -scheme Sessiz \
      -configuration Release \
      -sdk iphoneos \
      CODE_SIGN_IDENTITY="" \
      CODE_SIGNING_REQUIRED=NO \
      clean build
```

## Yaygın Hatalar

### "Scheme 'Sessiz' not found"
- Scheme adını kontrol edin: `xcodebuild -list -project Sessiz.xcodeproj`
- Doğru scheme adını kullanın

### "No such file or directory"
- Dosyaların GitHub'da olduğundan emin olun
- `.gitignore` dosyasının dosyaları engellemediğinden emin olun

### "Code signing is required"
- `CODE_SIGNING_REQUIRED=NO` parametresi eklenmiş olmalı
- Workflow'da bu parametre var

## Debug Workflow'u Çalıştırın

1. Debug workflow'unu GitHub'a yükleyin
2. Çalıştırın
3. Her adımın çıktısını kontrol edin
4. Hata mesajlarını paylaşın

Bu şekilde sorunu daha net tespit edebiliriz!

