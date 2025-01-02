import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:metersystem/models/meter.dart';
import 'package:metersystem/utlis/Colors.dart';
import 'package:metersystem/utlis/app_router.dart';
import 'package:metersystem/utlis/constant.dart';
import 'package:metersystem/utlis/helper_functions.dart';

import '../controller/meter_provider.dart';
import '../widgets/addMeterPopup.dart';
import '../widgets/deleteMeterDialog.dart';

class MeterListPage extends ConsumerWidget {
  const MeterListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meters = ref.watch(meterProvider);
    final meterNotifier = ref.read(meterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meters'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddMeterDialog(context, (name, number) async {
            await meterNotifier.addMeter(Meter(name: name, number: number));
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
                  onPressed: () => copyToClipboard(context,'${meter.number}'),
                  icon: const Icon(Icons.copy),
                ),IconButton(
                  onPressed: () => launchUrlString('${ConstantStrings.mepcoURL}${meter.number}'),
                  icon: const Icon(Icons.print),
                ),
                IconButton(
                  onPressed: () async {
                    showDeleteMeterDialog(context, meter.name, () async {
                      await meterNotifier.deleteMeter(meter.id);
                    });
                  },
                  icon:  Icon(Icons.delete, color: CColors.danger),
                ),
              ],
            ),
            onTap: () => context.push(RoutesStr.meterReading, extra: meter),
          );
        },
      ),
    );
  }
}
