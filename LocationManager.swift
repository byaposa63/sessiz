import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let dataUploader = DataUploader()
    private var isTracking = false
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // 10 metre değişiklikte güncelle
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func startTracking() {
        guard !isTracking else { return }
        
        // İzin kontrolü
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            beginLocationTracking()
        case .denied, .restricted:
            print("Konum izni reddedildi")
        @unknown default:
            break
        }
    }
    
    private func beginLocationTracking() {
        isTracking = true
        
        // Önemli konum değişikliklerini başlat (daha az pil tüketir)
        locationManager.startMonitoringSignificantLocationChanges()
        
        // Sürekli konum güncellemelerini başlat
        locationManager.startUpdatingLocation()
        
        // Bölge izleme (opsiyonel)
        setupRegionMonitoring()
    }
    
    func stopTracking() {
        isTracking = false
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "altitude": location.altitude,
            "accuracy": location.horizontalAccuracy,
            "timestamp": location.timestamp.timeIntervalSince1970,
            "speed": location.speed,
            "course": location.course
        ]
        
        // Veriyi kaydet ve yükle
        saveLocationData(locationData)
        dataUploader.uploadLocation(locationData)
        
        print("📍 Konum güncellendi: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Konum hatası: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedAlways:
            beginLocationTracking()
        case .authorizedWhenInUse:
            // When in use izni varsa, always için tekrar iste
            manager.requestAlwaysAuthorization()
        default:
            print("⚠️ Konum izni yetersiz")
        }
    }
    
    // MARK: - Region Monitoring
    
    private func setupRegionMonitoring() {
        // Ev, okul gibi önemli konumları izlemek için
        // Bu kısım opsiyonel, ihtiyaca göre özelleştirilebilir
    }
    
    // MARK: - Data Saving
    
    private func saveLocationData(_ data: [String: Any]) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsPath.appendingPathComponent("locations.json")
        
        var locations: [[String: Any]] = []
        
        // Mevcut verileri oku
        if let existingData = try? Data(contentsOf: filePath),
           let existingLocations = try? JSONSerialization.jsonObject(with: existingData) as? [[String: Any]] {
            locations = existingLocations
        }
        
        // Yeni veriyi ekle
        locations.append(data)
        
        // Dosyaya kaydet
        if let jsonData = try? JSONSerialization.data(withJSONObject: locations, options: .prettyPrinted) {
            try? jsonData.write(to: filePath)
        }
    }
}

