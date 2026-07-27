import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.onDeleted,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar:
      icon != null ? Icon(icon, size: 18) : null,
      label: Text(label),
      onDeleted: onDeleted,
    );
  }
}