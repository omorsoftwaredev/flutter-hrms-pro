import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class ShiftInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const ShiftInfoCard({
    super.key,
    required this.attendance,
  });

  // =============================================================
  // Helpers
  // =============================================================

  Widget _item(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 2,
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null || time.trim().isEmpty) {
      return '--';
    }

    return time;
  }

  // =============================================================
  // Build
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    final bool isDesktop = size.width >= 900;
    final double cardPadding = isDesktop ? 22 : 16;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),

      child: Padding(
        padding: EdgeInsets.all(cardPadding),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =====================================================
            // Header
            // =====================================================

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shift Information',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        'Shift schedule and attendance timing',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 6),

            // =====================================================
            // Attendance Metrics
            // =====================================================

            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
              ),
              child: Text(
                'Attendance Metrics',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ),

            _item(
              context,
              icon: Icons.work_history_outlined,
              title: 'Work Minutes',
              value: '${attendance.workMinutes} Minutes',
            ),

            // _item(
            //   context,
            //   icon: Icons.warning_amber_rounded,
            //   title: 'Late Minutes',
            //   value: '${attendance.lateMinutes} Minutes',
            // ),

            _item(
              context,
              icon: Icons.trending_up_rounded,
              title: 'Overtime',
              value: '${attendance.overtimeMinutes} Minutes',
            ),

            // _item(
            //   context,
            //   icon: Icons.exit_to_app_rounded,
            //   title: 'Early Exit',
            //   value: '${attendance.earlyExitMinutes} Minutes',
            // ),
          ],
        ),
      ),
    );
  }
}