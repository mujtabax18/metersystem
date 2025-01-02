import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metersystem/screens/backup/view/backupScreen.dart';

import '../models/meter.dart';
import '../screens/HomeScreen/view/HomeScreen.dart';
import '../screens/meter/MeterList/view/MeterListPage.dart';
import '../screens/meter/meterreading/view/meterreading.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RoutesStr.home,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: RoutesStr.meterList,
      builder: (context, state) => MeterListPage(),
    ),GoRoute(
      path: RoutesStr.meterReading, // Define a dynamic route with a parameter `id`
      builder: (context, state) {
       final id = state.extra as Meter; // Retrieve the parameter
        return MeterDetailPage(meter: id);
      },
    ),GoRoute(
      path: RoutesStr.backup,
      builder: (context, state) => BackupRestoreScreen(),
    ),
  ],
);

class RoutesStr{
  static String home='/';
  static String meterList='/meterList';
  static String meterReading='/meterReading';
  static String backup='/backup';
}