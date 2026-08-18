import 'package:flutter/material.dart';

class AttendanceSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const AttendanceSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double radius = isDesktop
        ? 14
        : isTablet
        ? 13
        : 12;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: 'Search Attendance...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),

        prefixIcon: Icon(
          Icons.search_rounded,
          color: colorScheme.onSurfaceVariant,
        ),

        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
          tooltip: 'Clear search',
          icon: Icon(
            Icons.clear_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            controller.clear();
            onChanged?.call('');
          },
        )
            : null,

        filled: true,

        fillColor: colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.35),

        contentPadding: EdgeInsets.symmetric(
          horizontal: isDesktop
              ? 16
              : isTablet
              ? 14
              : 12,
          vertical: isDesktop
              ? 16
              : isTablet
              ? 14
              : 12,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}