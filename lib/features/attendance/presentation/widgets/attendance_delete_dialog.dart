import 'package:flutter/material.dart';

Future<bool?> showAttendanceDeleteDialog(
    BuildContext context,
    ) {
  return showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text(
          'Delete Attendance',
        ),
        content: const Text(
          'Are you sure you want to delete this attendance?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}