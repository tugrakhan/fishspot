import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:fish_spot/models/fish_spot.dart';

class AddSpotBottomSheet extends StatefulWidget {
  final LatLng location;

  const AddSpotBottomSheet({super.key, required this.location});

  @override
  State<AddSpotBottomSheet> createState() => _AddSpotBottomSheetState();
}

class _AddSpotBottomSheetState extends State<AddSpotBottomSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _saveSpot() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) return;

    final newSpot = FishSpot(
      latitude: widget.location.latitude,
      longitude: widget.location.longitude,
      title: title,
      description: desc,
      date: DateTime.now(),
    );

    final box = Hive.box<FishSpot>('fish_spots');
    await box.add(newSpot);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add new fish spot',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),0
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _saveSpot,
            icon: const Icon(Icons.save),
            label: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
