import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/backup_restore_Provider.dart';

class BackupRestoreScreen extends ConsumerWidget {
  const BackupRestoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(backupRestoreProvider);
    final notifier = ref.read(backupRestoreProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (message != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ElevatedButton(
              onPressed: () => notifier.backupDatabase(),
              child: const Text('Backup Database to SQL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => notifier.restoreDatabase(),
              child: const Text('Restore Database'),
            ),
          ],
        ),
      ),
    );
  }
}
