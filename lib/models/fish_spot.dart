import 'package:hive/hive.dart';

//flutter packages pub run build_runner build console command for generating the adapter

part "fish_spot.g.dart";

@HiveType(typeId: 0)
class FishSpot extends HiveObject {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime date;

  FishSpot({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
    required this.date,
  });
}
