import 'package:flutter/material.dart';

void showAddMeterDialog(BuildContext context, Function(String name, String number) onAddMeter) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Meter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Meter Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Meter Number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final number = numberController.text.trim();

              if (name.isNotEmpty && number.isNotEmpty) {
                onAddMeter(name, number); // Call the provided callback
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: const Text('Add Meter'),
          ),
        ],
      );
    },
  );
}
