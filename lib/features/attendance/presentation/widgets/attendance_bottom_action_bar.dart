import 'package:flutter/material.dart';

class AttendanceBottomActionBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const AttendanceBottomActionBar({
    super.key,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text("Back"),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: FilledButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: const Text("Edit"),
          ),
        ),
      ],
    );
  }
}