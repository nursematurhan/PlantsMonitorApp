import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/plant.dart';
import 'plant_monitor_page.dart';

class PlantSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DatabaseReference plantsRef = FirebaseDatabase.instance.ref('plants');

    return Scaffold(
      appBar: AppBar(title: Text("Select a Plant")),
      body: StreamBuilder<DatabaseEvent>(
        stream: plantsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return Center(child: Text("No plants found."));
          }

          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final plants = data.entries.map((entry) {
            final plantData = Map<String, dynamic>.from(entry.value);
            return Plant.fromMap(plantData);
          }).toList();

          return ListView.builder(
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      plant.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(plant.name),
                  subtitle: Text("Moisture Range: ${plant.minMoisture} - ${plant.maxMoisture}"),
                  trailing: Icon(Icons.add_circle_outline),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlantMonitorPage(selectedPlant: plant),
                      ),
                    );
                  },
                ),
              );
            },
          );

        },
      ),
    );
  }
}
