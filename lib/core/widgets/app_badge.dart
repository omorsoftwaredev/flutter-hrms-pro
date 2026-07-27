import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.text,
    this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor:
      color ?? Theme.of(context).colorScheme.primary,
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}