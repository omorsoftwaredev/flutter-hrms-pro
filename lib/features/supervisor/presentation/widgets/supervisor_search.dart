/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Search
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SupervisorSearch({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search supervisor...',
        prefixIcon: const Icon(
          Icons.search_outlined,
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
          icon: const Icon(
            Icons.clear,
          ),
          onPressed: () {
            controller.clear();
            onClear?.call();
            onChanged?.call('');
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}