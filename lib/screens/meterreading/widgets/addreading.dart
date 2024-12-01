import 'package:flutter/material.dart';
import 'package:metersystem/models/meter.dart';

void showAddReadingDialog(BuildContext context, Function(Reading reading) onAddReading) {
  final TextEditingController readingController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Reading'),
        content: TextField(
          controller: readingController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter Reading',
            border: OutlineInputBorder(),
          ),
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
              final reading = int.tryParse(readingController.text.trim());
              if (reading != null && reading > 0) {
                onAddReading(Reading(value: reading, date: DateTime.now())); // Pass the reading back
                Navigator.of(context).pop(); // Close the dialog
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid reading.')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
