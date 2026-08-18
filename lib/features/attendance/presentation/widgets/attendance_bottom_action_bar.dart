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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double spacing = isDesktop
        ? 16
        : isTablet
        ? 14
        : 12;

    final double buttonHeight = isDesktop
        ? 52
        : 50;

    return Row(
      children: [
        // =========================================================
        // BACK
        // =========================================================

        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
              ),
              label: Text(
                'Back',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface,
                side: BorderSide(
                  color: colorScheme.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: spacing),

        // =========================================================
        // EDIT
        // =========================================================

        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: FilledButton.icon(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
              ),
              label: Text(
                'Edit',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}