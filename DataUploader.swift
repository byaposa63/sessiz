import Foundation
import UIKit

class DataUploader {
    
    // Sunucu URL'inizi buraya ekleyin
    private let serverURL = "https://papayawhip-falcon-938452.hostingersite.com/api/upload.php"
    private let deviceID: String
    
    init() {
        // Cihaz ID'sini al (veya oluştur)
        if let id = UserDefaults.standard.string(forKey: "device_id") {
            deviceID = id
        } else {
            deviceID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
            UserDefaults.standard.set(deviceID, forKey: "device_id")
        }
    }
    
    // MARK: - Konum Yükleme
    
    func uploadLocation(_ locationData: [String: Any]) {
        var data = locationData
        data["device_id"] = deviceID
        data["type"] = "location"
        
        uploadData(data) { success in
            if success {
                print("✅ Konum yüklendi")
            } else {
                print("❌ Konum yüklenemedi")
            }
        }
    }
    
    // MARK: - Ses Yükleme
    
    func uploadAudio(file: URL) {
        guard let audioData = try? Data(contentsOf: file) else {
            print("❌ Ses dosyası okunamadı")
            return
        }
        
        let base64Audio = audioData.base64EncodedString()
        
        let data: [String: Any] = [
            "device_id": deviceID,
            "type": "audio",
            "filename": file.lastPathComponent,
            "audio_data": base64Audio,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        uploadData(data) { [weak self] success in
            if success {
                // Başarılı yüklemeden sonra dosyayı sil
                try? FileManager.default.removeItem(at: file)
                print("✅ Ses yüklendi: \(file.lastPathComponent)")
            } else {
                print("❌ Ses yüklenemedi: \(file.lastPathComponent)")
            }
        }
    }
    
    // MARK: - Genel Yükleme Fonksiyonu
    
    private func uploadData(_ data: [String: Any], completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: serverURL) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data)
        } catch {
            print("❌ JSON serileştirme hatası: \(error)")
            completion(false)
            return
        }
        
        // Arka planda yükleme
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Yükleme hatası: \(error.localizedDescription)")
                // Hata durumunda veriyi yerel olarak sakla
                self.saveLocally(data)
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    print("❌ Sunucu hatası: \(httpResponse.statusCode)")
                    self.saveLocally(data)
                    completion(false)
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Yerel Kayıt
    
    private func saveLocally(_ data: [String: Any]) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsPath.appendingPathComponent("pending_uploads.json")
        
        var pending: [[String: Any]] = []
        
        if let existingData = try? Data(contentsOf: filePath),
           let existingPending = try? JSONSerialization.jsonObject(with: existingData) as? [[String: Any]] {
            pending = existingPending
        }
        
        pending.append(data)
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: pending, options: .prettyPrinted) {
            try? jsonData.write(to: filePath)
        }
    }
    
    // MARK: - Bekleyen Yüklemeleri Gönder
    
    func retryPendingUploads() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsPath.appendingPathComponent("pending_uploads.json")
        
        guard let data = try? Data(contentsOf: filePath),
              var pending = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return
        }
        
        for item in pending {
            if let type = item["type"] as? String {
                if type == "location" {
                    uploadLocation(item)
                } else if type == "audio" {
                    // Ses dosyası için özel işlem gerekebilir
                }
            }
        }
        
        // Başarılı yüklemelerden sonra dosyayı temizle
        try? FileManager.default.removeItem(at: filePath)
    }
}

