import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'plant_selection_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference tempRef = FirebaseDatabase.instance.ref('data/temperature');
  final DatabaseReference humRef = FirebaseDatabase.instance.ref('data/humidity');

  double? temperature;
  double? humidity;

  @override
  void initState() {
    super.initState();
    tempRef.onValue.listen((event) {
      final value = event.snapshot.value;
      setState(() {
        temperature = value is double ? value : double.tryParse(value.toString());
      });
    });

    humRef.onValue.listen((event) {
      final value = event.snapshot.value;
      setState(() {
        humidity = value is double ? value : double.tryParse(value.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    final valueStyle = TextStyle(fontSize: 16, color: Colors.grey[800]);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FDF7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.eco_outlined, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Welcome", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Weather Conditions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thermostat, color: Colors.redAccent),
                          const SizedBox(width: 10),
                          Text("Temperature:", style: labelStyle),
                          const Spacer(),
                          Text(
                            temperature != null ? "${temperature!.toStringAsFixed(1)} °C" : "--",
                            style: valueStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.water_drop, color: Colors.blueAccent),
                          const SizedBox(width: 10),
                          Text("Humidity:", style: labelStyle),
                          const Spacer(),
                          Text(
                            humidity != null ? "${humidity!.toStringAsFixed(1)} %" : "--",
                            style: valueStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PlantSelectionPage()));
                },
                icon: const Icon(Icons.local_florist),
                label: const Text("Go to Plant List"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
