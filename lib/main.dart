import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'responsive.dart';
import 'sensor_info_section.dart';
import 'controllers/sensor_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SensorController _sensorController = SensorController();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('sensorData');
  String? _latestKey; // To track the latest entry's key
  late Responsive responsive;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    responsive = Responsive(context);
  }

  Future<void> _manualRefresh() async {
    setState(() {}); // Triggers StreamBuilder to rebuild
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data refreshed!')),
      );
    }
  }

  Future<void> _deleteLatest() async {
    if (_latestKey != null) {
      await _dbRef.child(_latestKey!).remove();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Latest entry deleted!')),
        );
      }
      setState(() {});
    }
  }

  Future<void> _deleteAll() async {
    await _dbRef.remove();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All data deleted!')),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Use the responsive utility for adaptive sizing
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            // const Icon(Icons.cloud, color: Colors.blueGrey),
            SizedBox(width: responsive.wp(2)),
            Expanded(
              child: Text(
                'Weather Info',
                style: TextStyle(fontSize: 22),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.info_outline),
            tooltip: 'What do these values mean?',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('What do these values mean?'),
                  content: const SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '• Temperature: The current air temperature in Celsius (°C).'),
                        SizedBox(height: 4),
                        Text(
                            '• Humidity: The relative humidity of the air, as a percentage (%).'),
                        SizedBox(height: 4),
                        Text(
                            '• Pressure: Atmospheric pressure in hectopascals (hPa).'),
                        SizedBox(height: 4),
                        Text(
                            '• Rain (Analog): The raw value from the rain sensor. Lower means more water detected.'),
                        SizedBox(height: 4),
                        Text(
                            '• Rain (Digital): 0 means rain detected, 1 means dry.'),
                        SizedBox(height: 4),
                        Text(
                            '• LDR (Analog): The raw value from the light sensor. Lower means more light.'),
                        SizedBox(height: 4),
                        Text('• LDR (Digital): 0 means bright, 1 means dark.'),
                        SizedBox(height: 8),
                        Text(
                            'Sensor Status: Green means the sensor is working and reporting data. Red means the sensor is not available or not reporting.'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _manualRefresh,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.delete),
            tooltip: 'Delete latest',
            onPressed: _deleteLatest,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Delete ALL',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete all data?'),
                  content: const Text(
                      'Are you sure you want to delete ALL entries? This cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete All',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await _deleteAll();
              }
            },
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.list),
            tooltip: 'Show all entries',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AllEntriesPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _manualRefresh,
        child: StreamBuilder<DatabaseEvent>(
          stream: _sensorController.getLatestSensorDataStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              final dataMap = snapshot.data!.snapshot.value as Map;
              final key = dataMap.keys.first;
              final sensorData =
                  _sensorController.parseSensorData(dataMap[key]);
              _latestKey = key;
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: SensorInfoSection(
                        sensorData: sensorData, responsive: responsive),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class AllEntriesPage extends StatelessWidget {
  const AllEntriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref('sensorData');
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Entries'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: dbRef.orderByChild('timestamp').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final dataMap = snapshot.data!.snapshot.value as Map;
            final entries = dataMap.entries.toList()
              ..sort((a, b) {
                final aTime = a.value['timestamp'] ?? '';
                final bTime = b.value['timestamp'] ?? '';
                return bTime.compareTo(aTime); // newest first
              });
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, idx) {
                final entry = entries[idx].value;
                final isSmallScreen = MediaQuery.of(context).size.width < 400;
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.thermostat, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text('${entry['dht_temp_C']} °C',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            Icon(Icons.water_drop, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text('${entry['dht_hum_percent']} %'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.speed, color: Colors.green),
                            const SizedBox(width: 8),
                            Text('${entry['bmp280_pressure_hPa']} hPa'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (isSmallScreen) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.grain, color: Colors.blueGrey),
                                  const SizedBox(width: 8),
                                  Text('Rain: ${entry['rain_analog']}'),
                                  const SizedBox(width: 8),
                                  Text('Digital: ${entry['rain_digital']}'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.wb_sunny, color: Colors.amber),
                                  const SizedBox(width: 8),
                                  Text('LDR: ${entry['ldr_analog']}'),
                                  const SizedBox(width: 8),
                                  Text('Digital: ${entry['ldr_digital']}'),
                                ],
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Icon(Icons.grain, color: Colors.blueGrey),
                              const SizedBox(width: 8),
                              Text('Rain: ${entry['rain_analog']}'),
                              const SizedBox(width: 8),
                              Text('Digital: ${entry['rain_digital']}'),
                              const SizedBox(width: 16),
                              Icon(Icons.wb_sunny, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text('LDR: ${entry['ldr_analog']}'),
                              const SizedBox(width: 8),
                              Text('Digital: ${entry['ldr_digital']}'),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text('Timestamp: ${entry['timestamp']}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading entries'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
