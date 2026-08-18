import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';
import 'attendance_status_chip.dart';

class AttendanceSummaryCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceSummaryCard({
    super.key,
    required this.attendance,
  });

  Widget _item(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double iconSize = isDesktop
        ? 24
        : isTablet
        ? 22
        : 21;

    final double valueFontSize = isDesktop
        ? 19
        : isTablet
        ? 18
        : 17;

    final double titleFontSize = isDesktop
        ? 13
        : 12;

    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: iconSize,
            color: colorScheme.primary,
          ),

          const SizedBox(height: 8),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: titleFontSize,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _hours(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;

    return "${h}h ${m}m";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double cardPadding = isDesktop
        ? 24
        : isTablet
        ? 22
        : 18;

    final double titleSize = isDesktop
        ? 19
        : isTablet
        ? 18
        : 17;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isDesktop ? 18 : 16,
        ),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          children: [
            // =========================================================
            // HEADER
            // =========================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(
                            alpha: 0.10,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.summarize_outlined,
                          size: 21,
                          color: colorScheme.primary,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "Attendance Summary",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                AttendanceStatusChip(
                  status: attendance.attendanceStatus,
                ),
              ],
            ),

            SizedBox(
              height: isDesktop ? 24 : 20,
            ),

            // =========================================================
            // SUMMARY
            // =========================================================
            Container(
              padding: EdgeInsets.symmetric(
                vertical: isDesktop ? 18 : 16,
                horizontal: isDesktop ? 10 : 6,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.30,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _item(
                    context,
                    icon: Icons.schedule_rounded,
                    title: "Work",
                    value: _hours(
                      attendance.workMinutes,
                    ),
                  ),

                  _item(
                    context,
                    icon: Icons.timer_outlined,
                    title: "Late",
                    value: "${attendance.lateMinutes}m",
                  ),

                  _item(
                    context,
                    icon: Icons.trending_up_rounded,
                    title: "OT",
                    value: "${attendance.overtimeMinutes}m",
                  ),

                  _item(
                    context,
                    icon: Icons.logout_rounded,
                    title: "Early Exit",
                    value: "${attendance.earlyExitMinutes}m",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}