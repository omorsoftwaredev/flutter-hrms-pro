import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class AttendanceAnalyticsCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceAnalyticsCard({
    super.key,
    required this.attendance,
  });

  // =============================================================
  // ANALYTICS ITEM
  // =============================================================

  Widget _item({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: color.withValues(alpha: 0.12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // MINUTES FORMAT
  // =============================================================

  String _minutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;

    if (h == 0) {
      return '${m}m';
    }

    return '${h}h ${m}m';
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double cardPadding = isDesktop
        ? 22
        : isTablet
        ? 20
        : 16;

    final double titleSize = isDesktop ? 19 : 18;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
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
            // HEADER
            // =====================================================

            Row(
              children: [
                Container(
                  width: isDesktop ? 44 : 42,
                  height: isDesktop ? 44 : 42,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: colorScheme.primary,
                    size: isDesktop ? 23 : 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Attendance Analytics',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 14),

            // =====================================================
            // WORK + LATE
            // =====================================================

            Row(
              children: [
                _item(
                  context: context,
                  icon: Icons.work_history_outlined,
                  title: 'Work',
                  value: _minutes(
                    attendance.workMinutes,
                  ),
                  color: Colors.green,
                ),

                const SizedBox(width: 12),

                // _item(
                //   context: context,
                //   icon: Icons.alarm_outlined,
                //   title: 'Late',
                //   value: _minutes(
                //     attendance.lateMinutes,
                //   ),
                //   color: Colors.orange,
                // ),
              ],
            ),

            const SizedBox(height: 12),

            // =====================================================
            // OVERTIME + EARLY EXIT
            // =====================================================

            Row(
              children: [
                _item(
                  context: context,
                  icon: Icons.trending_up_rounded,
                  title: 'Overtime',
                  value: _minutes(
                    attendance.overtimeMinutes,
                  ),
                  color: colorScheme.primary,
                ),

                const SizedBox(width: 12),

                // _item(
                //   context: context,
                //   icon: Icons.logout_outlined,
                //   title: 'Early Exit',
                //   value: _minutes(
                //     attendance.earlyExitMinutes,
                //   ),
                //   color: colorScheme.error,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}