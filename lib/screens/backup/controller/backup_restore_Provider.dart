import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../../../services/backupService.dart';
import '../../../services/database_service.dart';
import '../../../services/restoreService.dart';

class BackupRestoreNotifier extends StateNotifier<String?> {
  BackupRestoreNotifier() : super(null);

  Future<void> backupDatabase() async {
    final databaseService = DatabaseService();
    final db = await databaseService.database;
    final backupPath = await BackupService.backupDatabaseToSQL(db);
    if (backupPath != null) {
      state = 'Backup saved at: $backupPath';
    } else {
      state = 'Backup failed';
    }
  }

  Future<void> restoreDatabase() async {
    final databaseService = DatabaseService();
    final db = await databaseService.database;
    await DatabaseRestoreService.restoreDatabaseFromSQL(db);
    state = 'Database restored successfully';
  }
}

// Riverpod provider for BackupRestoreNotifier
final backupRestoreProvider =
StateNotifierProvider<BackupRestoreNotifier, String?>(
      (ref) => BackupRestoreNotifier(),
);
