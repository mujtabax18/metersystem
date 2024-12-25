import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metersystem/screens/backup/view/backupScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/meter.dart';
import '../../../services/database_service.dart';
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
    List<Meter> meters1 = await DatabaseService().getAllMeters();
    print(meters);
    setState(() {
      meters = meters1;
    });
  }


  // Future<void> _saveMeters() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('meters', jsonEncode(meters));
  // }

  void _navigateToMeter(Meter meter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeterDetailPage(
          meter: meter,

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
  }  void _navigateToBackUPScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BackupRestoreScreen(

        ),
      ),
    );
  }

  // void _updateMeter(Meter updatedMeter) {
  //   // Update the meter in the list
  //   setState(() {
  //     final index = meters.indexWhere((m) => m.number == updatedMeter.number);
  //     if (index != -1) {
  //       meters[index] = updatedMeter;
  //     }
  //   });
  //   _saveMeters();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meters'),actions: [IconButton(onPressed: ()=>_navigateToBackUPScreen(), icon: Icon(Icons.backup))],),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddMeterDialog(context, (name, number) async {
            await DatabaseService().addMeter(Meter(name: name, number: number));
            _loadMeters();// Save meters to persistent storage
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
                      showDeleteMeterDialog(context, meter.name, () async {
                        await DatabaseService().deleteMeter(meter.id);
                        _loadMeters();

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
