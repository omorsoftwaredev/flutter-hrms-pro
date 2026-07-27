import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.controller,
    this.hint = 'Search...',
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      hintText: hint,
      leading: const Icon(Icons.search),
      onChanged: onChanged,
    );
  }
}