import 'package:flutter/material.dart';
import 'package:metersystem/screens/homescreen/view/MeterListPage.dart';
import 'package:metersystem/screens/meterreading/view/meterreading.dart';
import 'package:metersystem/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'models/meter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database; // Initialize database

  runApp(const MeterReadingApp());
}

class MeterReadingApp extends StatelessWidget {
  const MeterReadingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Meter Reading App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MeterListPage(),
    );
  }
}
