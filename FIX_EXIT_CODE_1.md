# Exit Code 1 Hatası Düzeltme

## Sorun
Exit code 1, build sırasında bir hata olduğunu gösterir. Muhtemel nedenler:
- Proje dosyası eksik veya hatalı
- Scheme bulunamıyor
- Swift dosyalarında syntax hatası
- Eksik dosyalar (Assets.xcassets, LaunchScreen.storyboard)

## Çözüm: Basit Build Workflow

GitHub'da `blank.yml` dosyasını şununla değiştirin:

```yaml
name: Build iOS .ipa (Simple)

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
    
    - name: Show project structure
      run: |
        echo "📁 Mevcut dosyalar:"
        ls -la
        echo ""
        echo "📁 Xcode projesi:"
        ls -la Sessiz.xcodeproj/ || echo "❌ Proje bulunamadı"
        echo ""
        echo "📄 Swift dosyaları:"
        ls -la *.swift || echo "❌ Swift dosyaları bulunamadı"
    
    - name: List schemes and targets
      run: |
        if [ -f "Sessiz.xcodeproj/project.pbxproj" ]; then
          echo "✅ Proje dosyası bulundu"
          echo "📋 Scheme'ler:"
          xcodebuild -list -project Sessiz.xcodeproj 2>&1 || echo "Liste alınamadı"
        else
          echo "❌ Proje dosyası bulunamadı!"
          exit 1
        fi
    
    - name: Build Archive
      run: |
        echo "📦 Archive oluşturuluyor..."
        xcodebuild clean archive \
          -project Sessiz.xcodeproj \
          -scheme Sessiz \
          -configuration Release \
          -archivePath ./build/Sessiz.xcarchive \
          -destination "generic/platform=iOS" \
          CODE_SIGN_IDENTITY="" \
          CODE_SIGNING_REQUIRED=NO \
          CODE_SIGNING_ALLOWED=NO \
          2>&1 | tee archive.log
        BUILD_STATUS=${PIPESTATUS[0]}
        if [ $BUILD_STATUS -ne 0 ]; then
          echo "❌ Archive başarısız! Exit code: $BUILD_STATUS"
          echo "📋 Hata detayları (son 100 satır):"
          tail -100 archive.log
          exit $BUILD_STATUS
        fi
        echo "✅ Archive başarılı!"
    
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
    
    - name: Find IPA file
      if: success()
      id: find_ipa
      run: |
        IPA_FILE=$(find ./build/export -name "*.ipa" 2>/dev/null | head -1)
        if [ -z "$IPA_FILE" ]; then
          echo "❌ IPA bulunamadı!"
          ls -la ./build/export/ || true
          exit 1
        fi
        echo "ipa_path=$IPA_FILE" >> $GITHUB_OUTPUT
        echo "✅ IPA: $IPA_FILE"
    
    - name: Upload IPA artifact
      if: success()
      uses: actions/upload-artifact@v4
      with:
        name: Sessiz.ipa
        path: ${{ steps.find_ipa.outputs.ipa_path }}
        retention-days: 30
    
    - name: Upload build logs
      if: failure()
      uses: actions/upload-artifact@v4
      with:
        name: build-logs
        path: archive.log
        if-no-files-found: ignore
        retention-days: 7
```

## Hata Mesajlarını Kontrol Edin

Workflow çalıştıktan sonra:

1. **"Build Archive" adımının çıktısını kontrol edin**
   - Son 100 satır hata mesajlarını gösterir
   - Hangi dosyanın eksik olduğunu görebilirsiniz

2. **"List schemes and targets" adımını kontrol edin**
   - Scheme adının doğru olup olmadığını gösterir

3. **Build logs artifact'ını indirin**
   - Hata başarısız olursa, "build-logs" artifact'ı oluşturulur
   - İndirip içeriğini kontrol edin

## Yaygın Hatalar ve Çözümleri

### "No such file or directory: Assets.xcassets"
**Çözüm:** Assets.xcassets klasörü oluşturun veya proje dosyasından kaldırın

### "Scheme 'Sessiz' not found"
**Çözüm:** `xcodebuild -list` çıktısındaki doğru scheme adını kullanın

### "Missing required architecture"
**Çözüm:** `-destination "generic/platform=iOS"` parametresi eklenmiş olmalı

### Swift syntax hatası
**Çözüm:** Swift dosyalarını kontrol edin, syntax hatalarını düzeltin

## Sonraki Adım

1. Workflow'u güncelleyin
2. Çalıştırın
3. "Build Archive" adımının çıktısını paylaşın
4. Hata mesajına göre düzeltme yapalım

