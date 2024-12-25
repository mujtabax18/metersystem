import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  static Future<String?> backupSharedPreferences() async {
    try {
      // Get all SharedPreferences data
      final prefs = await SharedPreferences.getInstance();
      final allPrefs = prefs.getKeys().fold<Map<String, dynamic>>({}, (map, key) {
        map[key] = prefs.get(key);
        return map;
      });

      // Convert to JSON
      final jsonString = jsonEncode(allPrefs);

      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final backupFile = File('${directory.path}/shared_prefs_backup.json');

      // Save JSON to a file
      await backupFile.writeAsString(jsonString);

      return backupFile.path; // Return the backup file path
    } catch (e) {
      print('Error during backup: $e');
      return null;
    }
  }
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
