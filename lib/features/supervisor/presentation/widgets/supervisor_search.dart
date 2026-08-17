/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Search
///
/// Version : 3.0.0
///
/// Features:
/// - Theme aware
/// - Light / Dark mode support
/// - Responsive layout
/// - Clear button
/// - Focus aware border
/// - HRMS Pro UI consistency
/// ===============================================================

import 'package:flutter/material.dart';

class SupervisorSearch extends StatefulWidget {
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
  State<SupervisorSearch> createState() => _SupervisorSearchState();
}

class _SupervisorSearchState extends State<SupervisorSearch> {
  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onControllerChanged);
  }

  // =============================================================
  // CONTROLLER CHANGE
  // =============================================================

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);

    super.dispose();
  }

  // =============================================================
  // CLEAR
  // =============================================================

  void _clear() {
    widget.controller.clear();

    widget.onClear?.call();
    widget.onChanged?.call('');

    if (mounted) {
      setState(() {});
    }
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;

        final double radius = isMobile ? 12 : 14;

        final double verticalPadding = isMobile ? 2 : 4;

        return TextField(
          controller: widget.controller,

          onChanged: widget.onChanged,

          textInputAction: TextInputAction.search,

          style: theme.textTheme.bodyMedium,

          decoration: InputDecoration(
            // ===================================================
            // HINT
            // ===================================================
            hintText: 'Search supervisor...',

            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),

            // ===================================================
            // PREFIX ICON
            // ===================================================
            prefixIcon: Icon(
              Icons.search_outlined,
              color: colorScheme.onSurfaceVariant,
            ),

            // ===================================================
            // CLEAR BUTTON
            // ===================================================
            suffixIcon: widget.controller.text.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear',

                    onPressed: _clear,

                    icon: const Icon(Icons.clear),

                    color: colorScheme.onSurfaceVariant,
                  ),

            // ===================================================
            // DEFAULT BORDER
            // ===================================================
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),

              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),

            // ===================================================
            // ENABLED BORDER
            // ===================================================
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),

              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),

            // ===================================================
            // FOCUSED BORDER
            // ===================================================
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),

              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),

            // ===================================================
            // ERROR BORDER
            // ===================================================
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),

              borderSide: BorderSide(color: colorScheme.error),
            ),

            // ===================================================
            // FILLED
            // ===================================================
            filled: true,

            fillColor: colorScheme.surfaceContainerLow,

            // ===================================================
            // CONTENT PADDING
            // ===================================================
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: verticalPadding,
            ),
          ),
        );
      },
    );
  }
}
