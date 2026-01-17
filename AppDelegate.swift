import UIKit
import CoreLocation
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var locationManager: LocationManager?
    var audioRecorder: AudioRecorder?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Konum yöneticisini başlat
        locationManager = LocationManager()
        locationManager?.startTracking()
        
        // Ses kaydediciyi başlat
        audioRecorder = AudioRecorder()
        audioRecorder?.startRecording()
        
        // Arka plan görevini ayarla
        setupBackgroundTask()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Arka plana geçildiğinde görevleri sürdür
        startBackgroundTask()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        endBackgroundTask()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        locationManager?.stopTracking()
        audioRecorder?.stopRecording()
    }
    
    private func setupBackgroundTask() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startBackgroundTask),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc private func startBackgroundTask() {
        endBackgroundTask()
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
}

