import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/shift_entity.dart';

class ShiftCard extends StatelessWidget {
  const ShiftCard({
    super.key,
    required this.shift,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  final ShiftEntity shift;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  // =============================================================
  // WEEK DAY
  // =============================================================

  String _weekDay(int? day) {
    switch (day) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '-';
    }
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isCompact = constraints.maxWidth < 380;

          final double horizontalPadding = isCompact ? 14 : 16;

          final double avatarRadius = isCompact ? 22 : 24;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =================================================
                // HEADER
                // =================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      child: Icon(
                        Icons.schedule_rounded,
                        size: isCompact ? 21 : 23,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shift.name.isEmpty ? '-' : shift.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // SHIFT CODE
                          if (shift.code.isNotEmpty)
                            Text(
                              'Code: ${shift.code}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          const SizedBox(height: 2),

                          Text(
                            shift.isNightShift ? 'Night Shift' : 'Day Shift',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 4),

                    // =============================================
                    // MENU
                    // =============================================
                    PopupMenuButton<String>(
                      tooltip: 'More options',
                      icon: const Icon(Icons.more_vert_rounded),
                      onSelected: (value) {
                        switch (value) {
                          case 'view':
                            onView?.call();
                            break;

                          case 'edit':
                            onEdit?.call();
                            break;

                          case 'status':
                            onToggleStatus?.call();
                            break;

                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility_outlined),
                              SizedBox(width: 10),
                              Text('View'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'status',
                          child: Row(
                            children: [
                              Icon(
                                shift.isActive
                                    ? Icons.block
                                    : Icons.check_circle_outline,
                                color: shift.isActive
                                    ? colorScheme.error
                                    : colorScheme.primary,
                              ),
                              const SizedBox(width: 10),
                              Text(shift.isActive ? 'Deactivate' : 'Activate'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: colorScheme.error,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Delete',
                                style: TextStyle(color: colorScheme.error),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // =================================================
                // SHIFT TIME
                // =================================================
                _InfoRow(
                  icon: Icons.access_time_rounded,
                  value: '${shift.startTime} → ${shift.endTime}',
                ),

                const SizedBox(height: 11),

                // =================================================
                // BREAK
                // =================================================
                _InfoRow(
                  icon: Icons.free_breakfast_outlined,
                  value: 'Break : ${shift.breakMinutes} Minutes',
                ),

                const SizedBox(height: 11),

                // =================================================
                // WORKING HOURS
                // =================================================
                _InfoRow(
                  icon: Icons.timelapse_rounded,
                  value:
                      'Minimum Working : '
                      '${shift.minimumWorkingHours.toStringAsFixed(2)} Hours',
                ),

                const SizedBox(height: 11),

                // =================================================
                // HALF DAY THRESHOLD
                // =================================================
                _InfoRow(
                  icon: Icons.hourglass_bottom_rounded,
                  value:
                      'Half Day After : '
                      '${shift.halfDayThresholdHours.toStringAsFixed(2)} Hours',
                ),

                const SizedBox(height: 11),

                // =================================================
                // LATE / EARLY GRACE
                // =================================================
                _InfoRow(
                  icon: Icons.timer_outlined,
                  value:
                      'Late Grace : ${shift.lateGraceMinutes} Min'
                      '  •  '
                      'Early Leave Grace : '
                      '${shift.earlyLeaveGraceMinutes} Min',
                ),

                const SizedBox(height: 14),

                // =================================================
                // ATTENDANCE REQUIREMENTS
                // =================================================
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _RequirementChip(
                      icon: shift.checkInRequired
                          ? Icons.login_rounded
                          : Icons.login_outlined,
                      label: shift.checkInRequired
                          ? 'Check-in Required'
                          : 'Check-in Optional',
                      isEnabled: shift.checkInRequired,
                    ),

                    _RequirementChip(
                      icon: shift.checkOutRequired
                          ? Icons.logout_rounded
                          : Icons.logout_outlined,
                      label: shift.checkOutRequired
                          ? 'Check-out Required'
                          : 'Check-out Optional',
                      isEnabled: shift.checkOutRequired,
                    ),
                  ],
                ),

                // =================================================
                // DESCRIPTION
                // =================================================
                if (shift.description.isNotEmpty) ...[
                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: .45,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Text(
                      shift.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // =================================================
                // TYPE / STATUS
                // =================================================
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusChip(
                      icon: shift.isNightShift
                          ? Icons.nights_stay_outlined
                          : Icons.wb_sunny_outlined,
                      label: shift.isNightShift ? 'Night Shift' : 'Day Shift',
                    ),

                    _StatusChip(
                      icon: shift.isFlexible
                          ? Icons.swap_horiz_rounded
                          : Icons.lock_outline_rounded,
                      label: shift.isFlexible ? 'Flexible' : 'Fixed',
                    ),

                    _StatusChip(
                      icon: shift.isActive
                          ? Icons.check_circle_outline_rounded
                          : Icons.cancel_outlined,
                      label: shift.isActive ? 'Active' : 'Inactive',
                      isStatus: true,
                      isActive: shift.isActive,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ===============================================================
// INFO ROW
// ===============================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 17, color: colorScheme.onSecondaryContainer),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===============================================================
// REQUIREMENT CHIP
// ===============================================================

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({
    required this.icon,
    required this.label,
    required this.isEnabled,
  });

  final IconData icon;
  final String label;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = isEnabled
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;

    final foregroundColor = isEnabled
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    final borderColor = isEnabled
        ? colorScheme.primary.withValues(alpha: .18)
        : colorScheme.outlineVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// STATUS CHIP
// ===============================================================

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    this.isStatus = false,
    this.isActive = false,
  });

  final IconData icon;
  final String label;

  final bool isStatus;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    Color borderColor;

    if (isStatus) {
      if (isActive) {
        backgroundColor = colorScheme.primaryContainer;
        foregroundColor = colorScheme.onPrimaryContainer;
        borderColor = colorScheme.primary.withValues(alpha: .18);
      } else {
        backgroundColor = colorScheme.errorContainer;
        foregroundColor = colorScheme.onErrorContainer;
        borderColor = colorScheme.error.withValues(alpha: .18);
      }
    } else {
      backgroundColor = colorScheme.surfaceContainerHighest;
      foregroundColor = colorScheme.onSurfaceVariant;
      borderColor = colorScheme.outlineVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foregroundColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
