import 'package:flutter/material.dart';
import 'models/sensor_data.dart';
import 'sensor_cards_widget.dart';
import 'sensor_status_widget.dart';
import 'responsive.dart';

class SensorInfoSection extends StatelessWidget {
  final SensorData sensorData;
  final Responsive responsive;
  const SensorInfoSection(
      {required this.sensorData, required this.responsive, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = responsive.isDesktop;
    final isTablet = responsive.isTablet;
    if (isDesktop) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.thermostat,
                  color: Colors.orange,
                  value: '${sensorData.dhtTempC} °C',
                  label: 'Temperature',
                  valueStyle: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                  description:
                      'The current air temperature measured in Celsius (°C).',
                ),
              ),
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.water_drop,
                  color: Colors.blue,
                  value: '${sensorData.dhtHumPercent} %',
                  label: 'Humidity',
                  valueStyle: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                  description:
                      'The relative humidity of the air, as a percentage (%).',
                ),
              ),
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.speed,
                  color: Colors.green,
                  value: '${sensorData.bmp280PressureHpa} hPa',
                  label: 'Pressure',
                  valueStyle: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  description: 'Atmospheric pressure in hectopascals (hPa).',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.grain,
                  color: Colors.blueGrey,
                  value: 'Rain: ${sensorData.rainAnalog}',
                  label: 'Digital: ${sensorData.rainDigital}',
                  description:
                      'Rain sensor readings. Analog shows the sensor value, digital is 1 (wet) or 0 (dry).',
                ),
              ),
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.wb_sunny,
                  color: Colors.amber,
                  value: 'LDR: ${sensorData.ldrAnalog}',
                  label: 'Digital: ${sensorData.ldrDigital}',
                  description:
                      'Light sensor (LDR) readings. Analog shows the light level, digital is 1 (bright) or 0 (dark).',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
              child: Column(
                children: [
                  Text('Sensor Status',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SensorStatusWidget(
                          label: 'DHT11', ok: sensorData.dht11Status == 'OK'),
                      SensorStatusWidget(
                          label: 'BMP280', ok: sensorData.bmp280Status == 'OK'),
                      SensorStatusWidget(
                          label: 'Rain',
                          ok: sensorData.rainAnalog != null &&
                              sensorData.rainDigital != null),
                      SensorStatusWidget(
                          label: 'LDR',
                          ok: sensorData.ldrAnalog != null &&
                              sensorData.ldrDigital != null),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Green means the sensor is working and reporting data. Red means the sensor is not available or not reporting.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Last updated:',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(sensorData.timestamp.toString(),
              style: const TextStyle(fontSize: 25)),
        ],
      );
    } else if (isTablet) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.thermostat,
                  color: Colors.orange,
                  value: '${sensorData.dhtTempC} °C',
                  label: 'Temperature',
                  valueStyle: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                  description:
                      'The current air temperature measured in Celsius (°C).',
                ),
              ),
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.water_drop,
                  color: Colors.blue,
                  value: '${sensorData.dhtHumPercent} %',
                  label: 'Humidity',
                  valueStyle: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  description:
                      'The relative humidity of the air, as a percentage (%).',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.speed,
                  color: Colors.green,
                  value: '${sensorData.bmp280PressureHpa} hPa',
                  label: 'Pressure',
                  valueStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  description: 'Atmospheric pressure in hectopascals (hPa).',
                ),
              ),
              Expanded(
                child: SensorCardWidget(
                  icon: Icons.grain,
                  color: Colors.blueGrey,
                  value: 'Rain: ${sensorData.rainAnalog}',
                  label: 'Digital: ${sensorData.rainDigital}',
                  description:
                      'Rain sensor readings. Analog shows the sensor value, digital is 1 (wet) or 0 (dry).',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SensorCardWidget(
            icon: Icons.wb_sunny,
            color: Colors.amber,
            value: 'LDR: ${sensorData.ldrAnalog}',
            label: 'Digital: ${sensorData.ldrDigital}',
            description:
                'Light sensor (LDR) readings. Analog shows the light level, digital is 1 (bright) or 0 (dark).',
          ),
          const SizedBox(height: 24),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Column(
                children: [
                  Text('Sensor Status',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 32,
                    runSpacing: 12,
                    children: [
                      SensorStatusWidget(
                          label: 'DHT11', ok: sensorData.dht11Status == 'OK'),
                      SensorStatusWidget(
                          label: 'BMP280', ok: sensorData.bmp280Status == 'OK'),
                      SensorStatusWidget(
                          label: 'Rain',
                          ok: sensorData.rainAnalog != null &&
                              sensorData.rainDigital != null),
                      SensorStatusWidget(
                          label: 'LDR',
                          ok: sensorData.ldrAnalog != null &&
                              sensorData.ldrDigital != null),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Green means the sensor is working and reporting data. Red means the sensor is not available or not reporting.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Last updated:',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(sensorData.timestamp.toString(),
              style: const TextStyle(fontSize: 14)),
        ],
      );
    } else {
      return Column(
        children: [
          Icon(Icons.thermostat, size: 48, color: Colors.orange),
          Text(
            '${sensorData.dhtTempC} °C',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text('Temperature', style: TextStyle(color: Colors.grey[700])),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'The current air temperature measured in Celsius (°C).',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 16),
          Icon(Icons.water_drop, size: 40, color: Colors.blue),
          Text(
            '${sensorData.dhtHumPercent} %',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text('Humidity', style: TextStyle(color: Colors.grey[700])),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'The relative humidity of the air, as a percentage (%).',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 16),
          Icon(Icons.speed, size: 40, color: Colors.green),
          Text(
            '${sensorData.bmp280PressureHpa} hPa',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Pressure', style: TextStyle(color: Colors.grey[700])),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'Atmospheric pressure in hectopascals (hPa).',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 24),
          Divider(),
          const SizedBox(height: 8),
          // Rain and LDR sensors in a column for small screens
          Column(
            children: [
              Column(
                children: [
                  Icon(Icons.grain, color: Colors.blueGrey),
                  Text('Rain: ${sensorData.rainAnalog}'),
                  Text('Digital: ${sensorData.rainDigital}'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      'Rain sensor readings. Analog shows the sensor value, digital is 0 (wet) or 1 (dry).',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  Icon(Icons.wb_sunny, color: Colors.amber),
                  Text('LDR: ${sensorData.ldrAnalog}'),
                  Text('Digital: ${sensorData.ldrDigital}'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      'Light sensor (LDR) readings. Analog shows the light level, digital is 0 (bright) or 1 (dark).',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(),
          const SizedBox(height: 8),
          Text('Sensor Status',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 32,
            runSpacing: 12,
            children: [
              SensorStatusWidget(
                  label: 'DHT11', ok: sensorData.dht11Status == 'OK'),
              SensorStatusWidget(
                  label: 'BMP280', ok: sensorData.bmp280Status == 'OK'),
              SensorStatusWidget(
                  label: 'Rain',
                  ok: sensorData.rainAnalog != null &&
                      sensorData.rainDigital != null),
              SensorStatusWidget(
                  label: 'LDR',
                  ok: sensorData.ldrAnalog != null &&
                      sensorData.ldrDigital != null),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Green means the sensor is working and reporting data. Red means the sensor is not available or not reporting.',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),
          Text('Last updated:',
              style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(sensorData.timestamp.toString(),
              style: const TextStyle(fontSize: 14)),
        ],
      );
    }
  }
}
