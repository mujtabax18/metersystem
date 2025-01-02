import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:metersystem/models/meter.dart';


import '../controller/meter_detail_provider.dart';
import '../widgets/addreading.dart';
import '../widgets/deletereading.dart';

class MeterDetailPage extends ConsumerWidget {
  final Meter meter;

  const MeterDetailPage({Key? key, required this.meter}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readings = ref.watch(meterDetailProvider(meter));
    final notifier = ref.read(meterDetailProvider(meter).notifier);

    return Scaffold(
      appBar: AppBar(title: Text(meter.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddReadingDialog(context, (reading) {
            if (meter.baseline == null) {
              notifier.setBaseline(reading);
            }
            notifier.addReading(reading);
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
              'Baseline: ${meter.baseline ?? 'Not Set'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: readings.length,
                itemBuilder: (context, index) {
                  final currentReading = readings[index].value;
                  final previousReading = index > 0 ? readings[index - 1].value : null;
                  final diffFromYesterday =
                  previousReading != null ? currentReading - previousReading : 0;
                  final diffFromBaseline =
                  meter.baseline != null ? currentReading - meter.baseline! : null;
                  String formattedDate =
                  DateFormat('dd/MM/yyyy').format(readings[index].date);

                  return ListTile(
                    title: Text('Reading: $currentReading \nDate: $formattedDate'),
                    subtitle: Text(
                      'Diff from Yesterday: $diffFromYesterday\n'
                          'Diff from Baseline: ${diffFromBaseline ?? 'Not Set'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => notifier.setBaseline(currentReading),
                          icon: Icon(
                            currentReading != meter.baseline ? Icons.star_border : Icons.star,
                            color: Colors.yellow,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDeleteReadingDialog(context, currentReading, () {
                              notifier.deleteReading(readings[index].id);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
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
