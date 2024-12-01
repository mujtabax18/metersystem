import 'package:flutter/material.dart';

void showDeleteReadingDialog(BuildContext context, int reading, Function() onDeleteConfirmed) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Reading'),
        content: Text('Are you sure you want to delete the reading: $reading?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without deleting
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onDeleteConfirmed(); // Perform deletion
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Emphasize the destructive action
            ),
          ),
        ],
      );
    },
  );
}
