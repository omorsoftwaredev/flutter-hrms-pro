import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';
import '../pages/attendance_details_page.dart';
import 'attendance_status_chip.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceEntity attendance;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AttendanceCard({
    super.key,
    required this.attendance,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double padding = isDesktop
        ? 22
        : isTablet
        ? 20
        : 16;

    final double titleSize = isDesktop
        ? 19
        : 18;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Keep existing functionality.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AttendanceDetailsPage(
                attendance: attendance,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =====================================================
              // ATTENDANCE HEADER
              // =====================================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      attendance.attendanceNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      theme.textTheme.titleMedium?.copyWith(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  AttendanceStatusChip(
                    status:
                    attendance.attendanceStatus,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // =====================================================
              // SHIFT
              // =====================================================

              Row(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      attendance.shiftName?.trim().isNotEmpty ==
                          true
                          ? attendance.shiftName!
                          : '--',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                      theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // =====================================================
              // DATE
              // =====================================================

              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
                    color: colorScheme.onSurfaceVariant,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      attendance.attendanceDate
                          .toString()
                          .split(' ')
                          .first,
                      style:
                      theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
              // CHECK IN / CHECK OUT
              // =====================================================

              LayoutBuilder(
                builder: (context, constraints) {
                  final bool compact =
                      constraints.maxWidth < 360;

                  if (compact) {
                    return Column(
                      children: [
                        _timeInfo(
                          context,
                          icon: Icons.login_outlined,
                          title: 'Check In',
                          value:
                          attendance.checkInTime ==
                              null
                              ? '--'
                              : attendance
                              .checkInTime
                              .toString(),
                        ),
                        const SizedBox(height: 10),
                        _timeInfo(
                          context,
                          icon: Icons.logout_outlined,
                          title: 'Check Out',
                          value:
                          attendance.checkOutTime ==
                              null
                              ? '--'
                              : attendance
                              .checkOutTime
                              .toString(),
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: _timeInfo(
                          context,
                          icon: Icons.login_outlined,
                          title: 'Check In',
                          value:
                          attendance.checkInTime ==
                              null
                              ? '--'
                              : attendance
                              .checkInTime
                              .toString(),
                        ),
                      ),

                      Container(
                        width: 1,
                        height: 38,
                        margin:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        color:
                        colorScheme.outlineVariant,
                      ),

                      Expanded(
                        child: _timeInfo(
                          context,
                          icon: Icons.logout_outlined,
                          title: 'Check Out',
                          value:
                          attendance.checkOutTime ==
                              null
                              ? '--'
                              : attendance
                              .checkOutTime
                              .toString(),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 14),

              // =====================================================
              // ACTIONS
              // =====================================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Edit',
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                    color: colorScheme.primary,
                    style: IconButton.styleFrom(
                      backgroundColor:
                      colorScheme.primary
                          .withOpacity(.08),
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    tooltip: 'Delete',
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                    ),
                    color: colorScheme.error,
                    style: IconButton.styleFrom(
                      backgroundColor:
                      colorScheme.error
                          .withOpacity(.08),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // TIME INFO
  // =============================================================

  Widget _timeInfo(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colorScheme.primary
                .withOpacity(.08),
            borderRadius:
            BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            size: 19,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}