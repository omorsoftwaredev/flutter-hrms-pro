/// ===============================================================
/// Flutter HRMS Pro
/// Company Account Delete Dialog
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';

Future<bool?> showCompanyAccountDeleteDialog(
    BuildContext context, {
      required String fullName,
    }) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        icon: const Icon(
          Icons.delete_forever,
          color: Colors.red,
          size: 40,
        ),
        title: const Text(
          'Delete Company Account',
        ),
        content: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              const TextSpan(
                text:
                'Are you sure you want to delete the account of\n\n',
              ),
              TextSpan(
                text: fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text:
                '\n\nThis action cannot be undone.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: const Icon(Icons.close),
            label: const Text('Cancel'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
          ),
        ],
      );
    },
  );
}