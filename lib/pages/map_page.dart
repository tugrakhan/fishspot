import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:fish_spot/services/location_service.dart';
import 'package:fish_spot/utils/constants.dart';
import 'package:fish_spot/widgets/spot_marker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fish_spot/models/fish_spot.dart';
import 'package:fish_spot/pages/saved_spots_page.dart';
import 'package:fish_spot/widgets/add_spot.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController _mapController;
  LatLng? _currentLocation;
  List<Marker> _markers = [];
  LatLng? _lastMovedLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getLocation();
    _loadSavedSpots();
    _loadSavedSpots(); // Load saved spots
    _getInitialLocation(); // Get initial location
    _startLocationTracking(); // Start location tracking
  }

  Future<void> _getLocation() async {
    final position = await LocationService.getCurrentPosition();
    if (position == null) return;

    final latLng = LatLng(position.latitude, position.longitude);

    setState(() => _currentLocation = latLng);

    // Harita çizildikten sonra move işlemini gerçekleştir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _mapController.move(latLng, 15.0);
      }
    });
  }

  void _loadSavedSpots() {
    final box = Hive.box<FishSpot>('fish_spots');
    final savedSpots = box.values.toList();

    final markers =
        savedSpots.map((spot) {
          return buildSpotMarker(
            LatLng(spot.latitude, spot.longitude),
            color: Colors.teal,
            icon: Icons.location_pin,
          );
        }).toList();

    setState(() {
      _markers = markers;
    });
  }

  void _openAddSpotBottomSheet() {
    if (_currentLocation == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddSpotBottomSheet(location: _currentLocation!),
    ).then((_) => _loadSavedSpots());
  }

  void _openSavedSpotsPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SavedSpotsPage()),
    );

    if (result != null && result is Map<String, double>) {
      final lat = result['latitude']!;
      final lng = result['longitude']!;
      final goto = LatLng(lat, lng);

      _mapController.move(goto, 16.0);
    }
  }

  Future<void> _getInitialLocation() async {
    final position = await LocationService.getCurrentPosition();
    if (position == null) return;

    final latLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLocation = latLng;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _mapController.move(latLng, 15.0);
      }
    });
  }

  void _startLocationTracking() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      final latLng = LatLng(position.latitude, position.longitude);

      // Sadece konum gerçekten değiştiyse move() uygula
      if (_lastMovedLocation == null ||
          _lastMovedLocation!.latitude != latLng.latitude ||
          _lastMovedLocation!.longitude != latLng.longitude) {
        _lastMovedLocation = latLng;

        setState(() => _currentLocation = latLng);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _mapController.move(latLng, 15.0);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.mapScreenTitle),
        actions: [
          Tooltip(
            message: "Saved spots",
            child: IconButton(
              icon: const Icon(Icons.list),
              onPressed: _openSavedSpotsPage,
            ),
          ),
        ],
      ),
      body:
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation!,
                      initialZoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.fish_spot',
                      ),
                      MarkerLayer(
                        markers: [
                          buildSpotMarker(_currentLocation!),
                          ..._markers,
                        ],
                      ),
                    ],
                  ),

                  //Sol alt köşede OpenStreetMap atıfı
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '© OpenStreetMap contributors',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 80,
                    right: 16,
                    child: Tooltip(
                      message: "Back to current location",
                      child: FloatingActionButton(
                        //ilk aşamada sağ üst köşede konumlandırmışken daha sonra
                        //sağ alt köşeye hemen konum kaydetme tuşumuzun üstüne aldığımız için boyutunu normal hale getirdim
                        //mini: true,
                        heroTag: 'to_current',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          if (_currentLocation != null) {
                            _mapController.move(_currentLocation!, 15.0);
                          }
                        },
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

      // ➕ Sağ alt köşe: Konum ekle butonu
      floatingActionButton: Tooltip(
        message: "Add a new spot",
        child: FloatingActionButton(
          onPressed: _openAddSpotBottomSheet,
          backgroundColor: Colors.white,
          heroTag: 'add_spot',
          child: const Icon(Icons.add_location_alt),
        ),
      ),
    );
  }
}
