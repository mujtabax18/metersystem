import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/backupService.dart';
import '../../../services/database_service.dart';
import '../../../services/restoreService.dart';


class BackupRestoreScreen extends StatelessWidget {


  const BackupRestoreScreen({ Key? key}) : super(key: key);

  Future<void> _backupDatabase(BuildContext context) async {
    final databaseService = DatabaseService();
    final db = await databaseService.database;
    final backupPath = await BackupService.backupDatabaseToSQL(db);
    if (backupPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup saved at: $backupPath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup failed')),
      );
    }
  }  Future<void> _backupDatabaseOld(BuildContext context) async {
    final backupPath = await BackupService.backupSharedPreferences();
    if (backupPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup saved at: $backupPath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup failed')),
      );
    }
  }

  Future<void> _restoreDatabase(BuildContext context) async {
    final databaseService = DatabaseService();
    final db = await databaseService.database;
    await DatabaseRestoreService.restoreDatabaseFromSQL(db);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database restored successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _backupDatabaseOld(context),
              child: const Text('Backup OLD Database to JSON'),
            ),
            const SizedBox(height: 20),  ElevatedButton(
              onPressed: () => _backupDatabase(context),
              child: const Text('Backup Database to SQL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _restoreDatabase(context),
              child: const Text('Restore Database'),
            ),
          ],
        ),
      ),
    );
  }
}
