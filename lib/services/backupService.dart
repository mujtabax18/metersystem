import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
 static Future<String?> backupDatabaseToSQL(Database db) async {
    try {
      // Get all tables
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");
      final sqlStatements = <String>[];

      // Iterate over tables
      for (final table in tables) {
        final tableName = table['name'] as String;

        // Get table schema
        final tableSchema = (await db.rawQuery("SELECT sql FROM sqlite_master WHERE name=?", [tableName])).first['sql'];
        sqlStatements.add('$tableSchema;');

        // Get all data from the table
        final rows = await db.rawQuery('SELECT * FROM $tableName');
        for (final row in rows) {
          final keys = row.keys.map((k) => '`$k`').join(', ');
          final values = row.values.map((v) => v is String ? "'${v.replaceAll("'", "''")}'" : v).join(', ');
          sqlStatements.add('INSERT INTO `$tableName` ($keys) VALUES ($values);');
        }
      }

      // Combine all SQL statements
      final sqlDump = sqlStatements.join('\n');

      // Save to a file
      final directory = await getApplicationDocumentsDirectory();
      final backupFile = File('${directory.path}/database_backup.sql');
      await backupFile.writeAsString(sqlDump);

      return backupFile.path; // Return the backup file path
    } catch (e) {
      print('Error during backup: $e');
      return null;
    }
  }
}
