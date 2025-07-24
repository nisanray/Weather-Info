import '../models/sensor_data.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorController {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('sensorData');

  Stream<DatabaseEvent> getLatestSensorDataStream() {
    return _dbRef.orderByChild('uid').limitToLast(1).onValue;
  }

  Future<void> deleteLatest(String? latestKey) async {
    if (latestKey != null) {
      await _dbRef.child(latestKey).remove();
    }
  }

  Future<void> deleteAll() async {
    await _dbRef.remove();
  }

  // Parse a map from Firebase into a SensorData model
  SensorData parseSensorData(Map data) {
    return SensorData.fromMap(data);
  }
}
