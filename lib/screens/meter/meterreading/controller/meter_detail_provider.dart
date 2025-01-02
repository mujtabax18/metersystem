import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metersystem/models/meter.dart';
import 'package:metersystem/services/database_service.dart';


class MeterDetailNotifier extends StateNotifier<List<Reading>> {
  final Meter meter;
  MeterDetailNotifier(this.meter) : super([]) {
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    final readings = await DatabaseService().getReadingsForMeter(meter.id!);
    state = readings;
  }

  Future<void> setBaseline(int reading) async {
    await DatabaseService().updateMeterBaseline(meter.id!, reading);
    meter.baseline = reading;
    state = List.from(state); // Trigger UI refresh
  }

  Future<void> addReading(int reading) async {
    final newReading = Reading(value: reading, date: DateTime.now(), meterId: meter.id!);
    await DatabaseService().addReading(newReading);
    await _loadReadings();
  }

  Future<void> deleteReading(int? id) async {
    if (id != null) {
      await DatabaseService().deleteReading(id, meter.id!);
      await _loadReadings();
    }
  }
}

// Provider for the MeterDetailNotifier
final meterDetailProvider =
StateNotifierProvider.family<MeterDetailNotifier, List<Reading>, Meter>(
      (ref, meter) => MeterDetailNotifier(meter),
);
