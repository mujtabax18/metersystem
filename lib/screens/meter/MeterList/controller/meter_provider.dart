import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/meter.dart';
import '../../../../services/database_service.dart';


// StateNotifier to manage the list of meters
class MeterNotifier extends StateNotifier<List<Meter>> {
  MeterNotifier() : super([]) {
    _init(); // Call the initialization method
  }

  // Initialization method to load meters
  Future<void> _init() async {
    await loadMeters();
  }

  // Load all meters
  Future<void> loadMeters() async {
    state = await DatabaseService().getAllMeters();
  }

  // Add a meter
  Future<void> addMeter(Meter meter) async {
    await DatabaseService().addMeter(meter);
    await loadMeters();
  }

  // Delete a meter
  Future<void> deleteMeter(int? id) async {
    if (id != null) {
      await DatabaseService().deleteMeter(id);
      await loadMeters();
    }
  }
}

// Provider for the MeterNotifier
final meterProvider = StateNotifierProvider<MeterNotifier, List<Meter>>(
      (ref) => MeterNotifier(),
);
