import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Marker buildSpotMarker(
  LatLng point, {
  Color color = Colors.red,
  IconData icon = Icons.location_on,
}) {
  return Marker(
    point: point,
    width: 40,
    height: 40,
    child: Icon(icon, color: color, size: 30), // ✅ YENİ SÜRÜM UYUMLU
  );
}
