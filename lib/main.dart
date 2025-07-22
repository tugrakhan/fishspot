import 'package:fish_spot/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/fish_spot.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   Hive.registerAdapter(FishSpotAdapter());
//   await Hive.openBox<FishSpot>('fish_spots');

//   runApp(MapPage());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FishSpotAdapter());
  await Hive.openBox<FishSpot>('fish_spots');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FishSpotter',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const MapPage(), // ✅ Burası doğru olmalı
      debugShowCheckedModeBanner: false,
    );
  }
}
