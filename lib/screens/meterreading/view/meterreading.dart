import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/meter.dart';
import '../widgets/addreading.dart';
import '../widgets/deletereading.dart';

class MeterDetailPage extends StatefulWidget {
  final Meter meter;
  final Function(Meter) onUpdate;

  const MeterDetailPage({Key? key, required this.meter, required this.onUpdate}) : super(key: key);

  @override
  State<MeterDetailPage> createState() => _MeterDetailPageState();
}

class _MeterDetailPageState extends State<MeterDetailPage> {
  void _addReading({required Reading reading}) {
    // Capture the current date

    // Check if the readings list is initialized, if not initialize it
    if (widget.meter.readings == null) {
      widget.meter.readings = [];
    }

    List<Reading> templist = widget.meter.readings;
    // Add a new reading with value and current date
    setState(() {
      templist.add(reading); // Safely add reading
      widget.meter.readings = templist;
    });

    // Notify parent to save the updated meter
    widget.onUpdate(widget.meter);
  }

  void _setReadingBaseline({required int baseline}) {
    if (baseline != null && baseline > 0) {
      setState(() {
        widget.meter.baseline = baseline;
      });
      widget.onUpdate(widget.meter); // Notify parent to save changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.meter.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddReadingDialog(context, (reading) {
            if (widget.meter.baseline == null) {
              _setReadingBaseline(baseline: reading.value);
            }
            _addReading(reading: reading); // Save the meter changes
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
                itemCount: widget.meter.readings.length,
                itemBuilder: (context, index) {
                  final currentReading = widget.meter.readings[index].value;
                  final previousReading = index > 0 ? widget.meter.readings[index - 1].value : null;
                  final diffFromYesterday = previousReading != null ? currentReading - previousReading : 0;
                  final diffFromBaseline = widget.meter.baseline != null ? currentReading - widget.meter.baseline! : null;
                  String formattedDate = DateFormat('dd/MM/yyyy').format(widget.meter.readings[index].date);
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
                            onPressed: () => _setReadingBaseline(baseline: currentReading),
                            icon: Icon(
                              currentReading != widget.meter.baseline ? Icons.star_border : Icons.star,
                              color: Colors.yellow,
                            )),
                        IconButton(
                            onPressed: () {
                              showDeleteReadingDialog(context, currentReading, () {
                                setState(() {
                                  widget.meter.readings.remove(currentReading); // Remove the selected reading
                                });
                                widget.onUpdate(widget.meter); // Save the meter changes
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
