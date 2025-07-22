import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fish_spot/models/fish_spot.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedSpotsPage extends StatelessWidget {
  const SavedSpotsPage({super.key});

  void _deleteSpot(int index, Box<FishSpot> box) {
    box.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Spots')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<FishSpot>('fish_spots').listenable(),
        builder: (context, Box<FishSpot> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text("No saved spots found."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final spot = box.getAt(index);

              if (spot == null) return const SizedBox();

              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.teal),
                title: Text(spot.title),
                subtitle: Text(
                  "${spot.description}\n${spot.latitude.toStringAsFixed(4)}, ${spot.longitude.toStringAsFixed(4)}",
                ),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteSpot(index, box);
                    } else if (value == 'map') {
                      final uri = Uri.parse(
                        'https://www.google.com/maps/search/?api=1&query=${spot.latitude},${spot.longitude}',
                      );
                      launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'map',
                          child: Text('Open in Google Maps'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                ),

                onTap: () {
                  Navigator.pop(context, {
                    'latitude': spot.latitude,
                    'longitude': spot.longitude,
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
