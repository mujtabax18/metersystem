import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRestoreService {
  static Future<void> restoreDatabaseFromSQL(Database db) async {
    try {
      // Pick the SQL file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['sql'],
      );

      if (result != null && result.files.isNotEmpty) {
        final sqlFile = XFile(result.files.single.path!);
        final sqlContent = await sqlFile.readAsString();

        // Execute SQL statements
        final statements = sqlContent.split(';');
        for (final statement in statements) {
          if (statement.trim().isNotEmpty) {
            await db.execute(statement);
          }
        }

        print('Database restored successfully');
      }
    } catch (e) {
      print('Error during restoration: $e');
    }
  }
}
