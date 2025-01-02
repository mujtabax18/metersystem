import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metersystem/screens/MeterList/view/MeterListPage.dart';
import 'package:metersystem/screens/backup/view/backupScreen.dart';
import 'package:metersystem/screens/meterreading/view/meterreading.dart';

import '../models/meter.dart';
import '../screens/HomeScreen/view/HomeScreen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/meterList',
      builder: (context, state) => MeterListPage(),
    ),GoRoute(
      path: '/meterReading', // Define a dynamic route with a parameter `id`
      builder: (context, state) {
       final id = state.extra as Meter; // Retrieve the parameter
        return MeterDetailPage(meter: id);
      },
    ),GoRoute(
      path: '/backup',
      builder: (context, state) => BackupRestoreScreen(),
    ),
  ],
);
