import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/plant.dart';
import 'plant_monitor_page.dart';

class PlantSelectionPage extends StatefulWidget {
  @override
  _PlantSelectionPageState createState() => _PlantSelectionPageState();
}

class _PlantSelectionPageState extends State<PlantSelectionPage> {
  final DatabaseReference plantsRef = FirebaseDatabase.instance.ref('plants');
  List<Plant> _allPlants = [];
  List<Plant> _filteredPlants = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    plantsRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final loadedPlants = data.entries.map((entry) {
          final plantData = Map<String, dynamic>.from(entry.value);
          return Plant.fromMap(plantData);
        }).toList();

        setState(() {
          _allPlants = loadedPlants;
          _filteredPlants = loadedPlants;
        });
      }
    });
  }

  void _filterPlants(String query) {
    setState(() {
      _searchQuery = query;
      _filteredPlants = _allPlants
          .where((plant) => plant.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Plant")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _filterPlants,
              decoration: InputDecoration(
                hintText: "Search plant...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _filteredPlants.isEmpty
                ? Center(child: Text("No matching plants."))
                : ListView.builder(
              itemCount: _filteredPlants.length,
              itemBuilder: (context, index) {
                final plant = _filteredPlants[index];
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
            ),
          ),
        ],
      ),
    );
  }
}
