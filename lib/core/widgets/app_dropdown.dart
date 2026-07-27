import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final bool enabled;

  final FormFieldValidator<T>? validator;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      validator: validator,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon:
        prefixIcon != null ? Icon(prefixIcon) : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}