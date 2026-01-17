import Foundation
import AVFoundation
import UIKit

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession?
    private let dataUploader = DataUploader()
    private var isRecording = false
    private var recordingTimer: Timer?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try recordingSession?.setActive(true)
        } catch {
            print("❌ Ses oturumu ayarlanamadı: \(error.localizedDescription)")
        }
    }
    
    func startRecording() {
        guard !isRecording else { return }
        
        // Mikrofon izni kontrolü
        checkMicrophonePermission { [weak self] granted in
            if granted {
                self?.beginRecording()
            } else {
                print("⚠️ Mikrofon izni reddedildi")
            }
        }
    }
    
    private func checkMicrophonePermission(completion: @escaping (Bool) -> Void) {
        let status = AVAudioSession.sharedInstance().recordPermission
        
        switch status {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func beginRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording_\(Date().timeIntervalSince1970).m4a")
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            
            // Arka planda çalışmayı sürdür
            setupBackgroundRecording()
            
            // Periyodik olarak kayıtları yükle
            startUploadTimer()
            
            print("🎤 Ses kaydı başlatıldı")
        } catch {
            print("❌ Kayıt başlatılamadı: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        guard isRecording else { return }
        
        audioRecorder?.stop()
        isRecording = false
        recordingTimer?.invalidate()
        
        print("🛑 Ses kaydı durduruldu")
    }
    
    private func setupBackgroundRecording() {
        // Arka planda kayıt yapabilmek için
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ Arka plan ses ayarı yapılamadı: \(error.localizedDescription)")
        }
    }
    
    private func startUploadTimer() {
        // Her 5 dakikada bir kayıtları yükle
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.uploadRecordings()
        }
    }
    
    private func uploadRecordings() {
        let documentsPath = getDocumentsDirectory()
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            let audioFiles = files.filter { $0.pathExtension == "m4a" }
            
            for file in audioFiles {
                dataUploader.uploadAudio(file: file)
            }
        } catch {
            print("❌ Kayıt dosyaları okunamadı: \(error.localizedDescription)")
        }
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // Kayıt tamamlandı, yükle
            dataUploader.uploadAudio(file: recorder.url)
            
            // Yeni kayıt başlat
            if isRecording {
                beginRecording()
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("❌ Kayıt hatası: \(error?.localizedDescription ?? "Bilinmeyen hata")")
    }
    
    // MARK: - Helper
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

