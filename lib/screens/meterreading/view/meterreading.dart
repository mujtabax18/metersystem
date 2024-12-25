import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/meter.dart';
import '../../../services/database_service.dart';
import '../widgets/addreading.dart';
import '../widgets/deletereading.dart';

class MeterDetailPage extends StatefulWidget {
  final Meter meter;


  const MeterDetailPage({Key? key, required this.meter}) : super(key: key);

  @override
  State<MeterDetailPage> createState() => _MeterDetailPageState();
}

class _MeterDetailPageState extends State<MeterDetailPage> {
  List<Reading> _readings = [];

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  void _setBaseline(int reading) async {
    await DatabaseService().updateMeterBaseline(widget.meter.id!, reading);
    setState(() {
      widget.meter.baseline = reading; // Update the meter baseline in the UI
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Baseline set to ${reading}')),
    );
  }
  Future<void> _loadReadings() async {
    List<Reading> readings = await DatabaseService().getReadingsForMeter(widget.meter.id!);
    setState(() {
      _readings = readings;
    });
  }
  void _addReading({required int reading1}) async {
    Reading newReading = Reading(value: reading1, date: DateTime.now(), meterId: widget.meter.id!);
    await DatabaseService().addReading(newReading);
    _loadReadings();
  }

  void _deleteReading(int? id) async {
    await DatabaseService().deleteReading(id, widget.meter.id!);
    _loadReadings();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.meter.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddReadingDialog(context, (reading) {
            if (widget.meter.baseline == null) {
              _setBaseline(reading);
            }
            _addReading(reading1: reading); // Save the meter changes
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Baseline: ${widget.meter.baseline ?? 'Not Set'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _readings.length,
                itemBuilder: (context, index) {
                  final currentReading = _readings[index].value;
                  final previousReading = index > 0 ? _readings[index - 1].value : null;
                  final diffFromYesterday = previousReading != null ? currentReading - previousReading : 0;
                  final diffFromBaseline = widget.meter.baseline != null ? currentReading - widget.meter.baseline! : null;
                  String formattedDate = DateFormat('dd/MM/yyyy').format(_readings[index].date);
                  return ListTile(
                    title: Text('Reading: $currentReading \nDate: ${formattedDate}'),
                    subtitle: Text(
                      'Diff from Yesterday: $diffFromYesterday\n'
                      'Diff from Baseline: ${diffFromBaseline ?? 'Not Set'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => _setBaseline(currentReading),
                            icon: Icon(
                              currentReading != widget.meter.baseline ? Icons.star_border : Icons.star,
                              color: Colors.yellow,
                            )),
                        IconButton(
                            onPressed: () {
                              showDeleteReadingDialog(context, currentReading, () {
                                _deleteReading(_readings[index].id,);
                               _loadReadings();
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
