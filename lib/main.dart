import 'package:flutter/material.dart';
import 'package:metersystem/screens/homescreen/view/MeterListPage.dart';
import 'package:metersystem/screens/meterreading/view/meterreading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'models/meter.dart';

void main() {
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
