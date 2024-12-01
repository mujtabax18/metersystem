import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/meter.dart';
import '../../billwebview/view/meterwebview.dart';
import '../../meterreading/view/meterreading.dart';
import '../widgets/addMeterPopup.dart';
import '../widgets/deleteMeterDialog.dart';

class MeterListPage extends StatefulWidget {
  const MeterListPage({Key? key}) : super(key: key);

  @override
  State<MeterListPage> createState() => _MeterListPageState();
}

class _MeterListPageState extends State<MeterListPage> {
  List<Meter> meters = [];
  @override
  void initState() {
    super.initState();
    _loadMeters();
  }

  Future<void> _loadMeters() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMeters = prefs.getString('meters');

    setState(() {
      meters = storedMeters != null ? List<Meter>.from(jsonDecode(storedMeters).map((e) => Meter.fromJson(e))) : [];
    });
  }

  Future<void> _saveMeters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('meters', jsonEncode(meters));
  }

  void _navigateToMeter(Meter meter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeterDetailPage(
          meter: meter,
          onUpdate: _updateMeter,
        ),
      ),
    );
  }

  void _navigateToMeterWebView(Meter meter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeterWebViewPage(
          meterNumber: meter.number,
        ),
      ),
    );
  }

  void _updateMeter(Meter updatedMeter) {
    // Update the meter in the list
    setState(() {
      final index = meters.indexWhere((m) => m.number == updatedMeter.number);
      if (index != -1) {
        meters[index] = updatedMeter;
      }
    });
    _saveMeters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meters')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddMeterDialog(context, (name, number) {
            setState(() {
              meters.add(Meter(name: name, number: number)); // Add new meter
            });
            _saveMeters(); // Save meters to persistent storage
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: meters.length,
        itemBuilder: (context, index) {
          final meter = meters[index];
          return ListTile(
            title: Text(meter.name),
            subtitle: Text('Number: ${meter.number}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      showDeleteMeterDialog(context, meter.name, () {
                        setState(() {
                          meters.remove(meter); // Remove the selected meter
                        });
                        _saveMeters(); // Save changes to persistent storage
                      });
                    },
                    icon: const Icon(Icons.delete, color: Colors.red)),
                IconButton(onPressed: () => _navigateToMeterWebView(meter), icon: const Icon(Icons.web_sharp)),
                const Icon(Icons.arrow_forward),
              ],
            ),
            onTap: () => _navigateToMeter(meter),
          );
        },
      ),
    );
  }
}
