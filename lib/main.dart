import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plant_monitor_app/screens/home_screen.dart';
import 'screens/plant_selection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PlantMonitorApp());
}

class PlantMonitorApp extends StatelessWidget {
  const PlantMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Monitor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}