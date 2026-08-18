import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';
import 'attendance_status_chip.dart';

class AttendanceBasicInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceBasicInfoCard({
    super.key,
    required this.attendance,
  });

  // =============================================================
  // INFO ROW
  // =============================================================

  Widget _row(
      BuildContext context,
      String title,
      String value,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          flex: 4,
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // DIVIDER
  // =============================================================

  Widget _divider(BuildContext context) {
    return Divider(
      height: 24,
      color: Theme.of(context)
          .colorScheme
          .outlineVariant,
    );
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
          children: [
            // =====================================================
            // ATTENDANCE NO
            // =====================================================

            _row(
              context,
              'Attendance No',
              attendance.attendanceNo,
            ),

            _divider(context),

            // =====================================================
            // DATE
            // =====================================================

            _row(
              context,
              'Date',
              attendance.attendanceDate
                  .toString()
                  .split(' ')
                  .first,
            ),

            _divider(context),

            // =====================================================
            // CHECK IN
            // =====================================================

            _row(
              context,
              'Check In',
              attendance.checkInTime == null
                  ? '--'
                  : attendance.checkInTime.toString(),
            ),

            _divider(context),

            // =====================================================
            // CHECK OUT
            // =====================================================

            _row(
              context,
              'Check Out',
              attendance.checkOutTime == null
                  ? '--'
                  : attendance.checkOutTime.toString(),
            ),

            _divider(context),

            // =====================================================
            // STATUS
            // =====================================================

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Status',
                    style:
                    theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AttendanceStatusChip(
                      status:
                      attendance.attendanceStatus,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}