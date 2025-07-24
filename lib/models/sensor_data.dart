class SensorData {
  final int? uid;
  final String? timestamp;
  final String? dhtTempC;
  final String? dhtHumPercent;
  final String? dht11Status;
  final String? bmp280TempC;
  final String? bmp280PressureHpa;
  final String? bmp280Status;
  final String? rainAnalog;
  final String? rainDigital;
  final String? ldrAnalog;
  final String? ldrDigital;

  SensorData({
    this.uid,
    this.timestamp,
    this.dhtTempC,
    this.dhtHumPercent,
    this.dht11Status,
    this.bmp280TempC,
    this.bmp280PressureHpa,
    this.bmp280Status,
    this.rainAnalog,
    this.rainDigital,
    this.ldrAnalog,
    this.ldrDigital,
  });

  factory SensorData.fromMap(Map data) {
    return SensorData(
      uid: int.tryParse(data['uid']?.toString() ?? ''),
      timestamp: data['timestamp']?.toString(),
      dhtTempC: data['dht_temp_C']?.toString(),
      dhtHumPercent: data['dht_hum_percent']?.toString(),
      dht11Status: data['dht11_status']?.toString(),
      bmp280TempC: data['bmp280_temp_C']?.toString(),
      bmp280PressureHpa: data['bmp280_pressure_hPa']?.toString(),
      bmp280Status: data['bmp280_status']?.toString(),
      rainAnalog: data['rain_analog']?.toString(),
      rainDigital: data['rain_digital']?.toString(),
      ldrAnalog: data['ldr_analog']?.toString(),
      ldrDigital: data['ldr_digital']?.toString(),
    );
  }
}

