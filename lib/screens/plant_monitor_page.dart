import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/plant.dart';

class PlantMonitorPage extends StatefulWidget {
  final Plant selectedPlant;

  const PlantMonitorPage({Key? key, required this.selectedPlant}) : super(key: key);

  @override
  _PlantMonitorPageState createState() => _PlantMonitorPageState();
}

class _PlantMonitorPageState extends State<PlantMonitorPage> {
  late final DatabaseReference _moistureRef;
  late final Stream<DatabaseEvent> _moistureStream;

  @override
  void initState() {
    super.initState();
    _moistureRef = FirebaseDatabase.instance.ref('data/soilMoisture');
    _moistureStream = _moistureRef.onValue;
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.selectedPlant;

    return Scaffold(
      appBar: AppBar(title: Text("Monitoring ${plant.name}")),
      body: StreamBuilder<DatabaseEvent>(
        stream: _moistureStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final value = snapshot.data?.snapshot.value;
          final moisture = value is int ? value : int.tryParse(value.toString() ?? '');

          final isSafe = moisture != null &&
              moisture >= plant.minMoisture &&
              moisture <= plant.maxMoisture;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (plant.imageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Image.network(
                      plant.imageUrl,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                Text("${plant.name}", style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 16),
                Text(
                  moisture != null ? "Current Moisture: $moisture" : "Reading moisture...",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                if (moisture != null)
                  Text(
                    isSafe ? "✅ Moisture is within range" : "⚠️ Dangerous moisture level!",
                    style: TextStyle(
                      fontSize: 18,
                      color: isSafe ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}