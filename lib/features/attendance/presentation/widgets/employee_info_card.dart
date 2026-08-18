import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class EmployeeInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const EmployeeInfoCard({
    super.key,
    required this.attendance,
  });

  Widget _item(
      BuildContext context, {
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            ': ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    final bool isDesktop = size.width >= 900;
    final bool isTablet = size.width >= 600 && size.width < 900;

    final double padding = isDesktop
        ? 24
        : isTablet
        ? 20
        : 16;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // Header
            // =========================================================
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Employee Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Divider(
              height: 20,
              color: colorScheme.outlineVariant,
            ),

            const SizedBox(height: 4),

            // =========================================================
            // Employee Information
            // =========================================================
            _item(
              context,
              title: 'Employee ID',
              value: attendance.employeeId ?? '--',
            ),

            _item(
              context,
              title: 'Department',
              value: attendance.departmentId ?? '--',
            ),

            _item(
              context,
              title: 'Designation',
              value: attendance.designationId ?? '--',
            ),

            _item(
              context,
              title: 'Shift',
              value: attendance.shiftName ?? '--',
            ),

            _item(
              context,
              title: 'Attendance No',
              value: attendance.attendanceNo,
            ),
          ],
        ),
      ),
    );
  }
}