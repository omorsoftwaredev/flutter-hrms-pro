import 'package:flutter/material.dart';

class EmployeeAccountDeleteDialog
    extends StatelessWidget {
  const EmployeeAccountDeleteDialog({
    super.key,
  });

  static Future<bool?> show(
      BuildContext context,
      ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
      const EmployeeAccountDeleteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.red,
        size: 42,
      ),
      title: const Text(
        'Delete Employee Account',
      ),
      content: const Text(
        'Are you sure you want to delete this employee account?\n\n'
            'This action cannot be undone.',
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(
              context,
              false,
            );
          },
          child: const Text(
            'Cancel',
          ),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              true,
            );
          },
          icon: const Icon(
            Icons.delete,
          ),
          label: const Text(
            'Delete',
          ),
        ),
      ],
    );
  }
}