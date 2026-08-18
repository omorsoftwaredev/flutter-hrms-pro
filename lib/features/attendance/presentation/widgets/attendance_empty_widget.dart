import 'package:flutter/material.dart';

class AttendanceEmptyWidget extends StatelessWidget {
  const AttendanceEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double iconSize = isDesktop
        ? 86
        : isTablet
        ? 82
        : 76;

    final double titleSize = isDesktop
        ? 19
        : 18;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop
              ? 40
              : isTablet
              ? 32
              : 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =====================================================
            // ICON
            // =====================================================

            Container(
              width: iconSize + 28,
              height: iconSize + 28,
              decoration: BoxDecoration(
                color: colorScheme.primary
                    .withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.fact_check_outlined,
                size: iconSize,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            // =====================================================
            // TITLE
            // =====================================================

            Text(
              'No Attendance Found',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: titleSize,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            // =====================================================
            // DESCRIPTION
            // =====================================================

            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Text(
                'Tap the + button to add attendance.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}