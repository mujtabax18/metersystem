import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metersystem/services/database_service.dart';
import 'package:metersystem/utlis/app_router.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database; // Initialize database

  runApp( ProviderScope( // Initializes Riverpod
    child: MeterReadingApp(),
  ),);
}

class MeterReadingApp extends StatelessWidget {
  const MeterReadingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Home Helper',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,
    );
  }
}
