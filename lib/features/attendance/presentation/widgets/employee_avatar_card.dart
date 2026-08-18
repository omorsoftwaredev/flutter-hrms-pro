import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class EmployeeAvatarCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const EmployeeAvatarCard({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final size = MediaQuery.sizeOf(context);

    final bool isDesktop = size.width >= 900;
    final bool isTablet = size.width >= 600 && size.width < 900;

    final double cardPadding = isDesktop
        ? 28
        : isTablet
        ? 24
        : 20;

    final double avatarRadius = isDesktop
        ? 48
        : isTablet
        ? 44
        : 42;

    final String initial = attendance.attendanceNo.isNotEmpty
        ? attendance.attendanceNo[0].toUpperCase()
        : '?';

    final String employeeId = attendance.employeeId ?? '--';

    final String date = attendance.attendanceDate
        .toString()
        .split(' ')
        .first;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          children: [
            // =========================================================
            // Avatar
            // =========================================================
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withValues(alpha: 0.10),
              ),
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                child: Text(
                  initial,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: isDesktop ? 18 : 16,
            ),

            // =========================================================
            // Attendance Number
            // =========================================================
            Text(
              attendance.attendanceNo,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            // =========================================================
            // Employee ID
            // =========================================================
            Text(
              employeeId,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(
              height: isDesktop ? 20 : 16,
            ),

            // =========================================================
            // Information Chips
            // =========================================================
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _infoChip(
                  context,
                  icon: Icons.badge_outlined,
                  label: attendance.attendanceStatus,
                  color: colorScheme.primary,
                ),

                _infoChip(
                  context,
                  icon: Icons.calendar_today_outlined,
                  label: date,
                  color: colorScheme.secondary,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 220,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 17,
            color: color,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}