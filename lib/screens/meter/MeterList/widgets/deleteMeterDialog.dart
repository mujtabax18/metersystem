import 'package:flutter/material.dart';

void showDeleteMeterDialog(BuildContext context, String meterName, Function() onDeleteConfirmed) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Meter'),
        content: Text('Are you sure you want to delete the meter "$meterName"?\n'
            'This will also delete all associated readings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without deleting
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onDeleteConfirmed(); // Call the provided callback for deletion
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Highlight the destructive action
            ),
          ),
        ],
      );
    },
  );
}
