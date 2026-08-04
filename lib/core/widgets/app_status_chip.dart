import 'package:flutter/material.dart';

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        isActive
            ? Icons.check_circle
            : Icons.cancel,
        color: Colors.white,
        size: 18,
      ),
      backgroundColor:
      isActive ? Colors.green : Colors.red,
      label: Text(
        isActive ? "Active" : "Inactive",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}