import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/attendance_report_model.dart';
import '../../domain/entities/attendance_report_entity.dart';

class AttendanceReportItem extends StatelessWidget {
  const AttendanceReportItem({
    super.key,
    required this.item,
  });

  final AttendanceReportModel item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: 0.55,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(
              alpha: 0.06,
            ),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 480;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSection(context),

                const SizedBox(height: 10),

                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant.withValues(
                    alpha: 0.45,
                  ),
                ),

                const SizedBox(height: 10),

                _buildTimeSection(context),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: constraints.maxWidth < 600
                    ? 120
                    : 150,
                child: _buildDateSection(context),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildTimeSection(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // DATE + STATUS
  // ============================================================

  Widget _buildDateSection(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('dd-MMM-yy').format(item.date),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 5),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: _statusColor(
              context,
              item.status,
            ).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            item.statusText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _statusColor(
                context,
                item.status,
              ),
            ),
          ),
        ),

        // ========================================================
        // LATE + EARLY OUT SUMMARY
        // ========================================================

        if (item.lateMinutes > 0) ...[
          const SizedBox(height: 6),
          _smallInfo(
            context,
            icon: Icons.schedule_rounded,
            text: 'Late ${item.lateMinutes} min',
            color: Colors.orange,
          ),
        ],

        if (item.earlyExitMinutes > 0) ...[
          const SizedBox(height: 4),
          _smallInfo(
            context,
            icon: Icons.logout_rounded,
            text: 'Early Out ${item.earlyExitMinutes} min',
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ],
    );
  }

  // ============================================================
  // SMALL INFO
  // ============================================================

  Widget _smallInfo(
      BuildContext context, {
        required IconData icon,
        required String text,
        required Color color,
      }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: color,
        ),

        const SizedBox(width: 4),

        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TIME SECTION
  // ============================================================

  Widget _buildTimeSection(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (item.status ==
        AttendanceReportStatus.dayOff ||
        item.status ==
            AttendanceReportStatus.absent ||
        item.status ==
            AttendanceReportStatus.leave ||
        item.status ==
            AttendanceReportStatus.holiday) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              _statusMessage(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _timeRow(
          context,
          label: 'In',
          time: item.checkInTime,
          address: item.checkInAddress,
          suffix: 'Entry',
          icon: Icons.login_rounded,
        ),

        const SizedBox(height: 10),

        _timeRow(
          context,
          label: 'Out',
          time: item.checkOutTime,
          address: item.checkOutAddress,
          suffix: 'Exit',
          icon: Icons.logout_rounded,
        ),

        // ========================================================
        // WORK / LATE / EARLY OUT
        // ========================================================

        const SizedBox(height: 10),

        _buildWorkSummary(context),
      ],
    );
  }

  // ============================================================
  // TIME ROW
  // ============================================================

  Widget _timeRow(
      BuildContext context, {
        required String label,
        required DateTime? time,
        required String? address,
        required String suffix,
        required IconData icon,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final timeText = time == null
        ? '-'
        : DateFormat(
      'hh:mm a',
    ).format(
      time.toLocal(),
    );

    final location =
    address == null ||
        address.trim().isEmpty
        ? '-'
        : address.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(
              alpha: 0.10,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 17,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.35,
              ),
              children: [
                TextSpan(
                  text: '$label : ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                TextSpan(
                  text: timeText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),

                const TextSpan(
                  text: ' - ',
                ),

                TextSpan(
                  text: location,
                ),

                TextSpan(
                  text: ' - $suffix',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // WORK SUMMARY
  // ============================================================

  Widget _buildWorkSummary(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final children = <Widget>[];

    // Work time
    if (item.workMinutes > 0) {
      children.add(
        _summaryChip(
          context,
          icon: Icons.access_time_rounded,
          label: 'Work',
          value: _formatMinutes(
            item.workMinutes,
          ),
          color: colorScheme.primary,
        ),
      );
    }

    // Late
    if (item.lateMinutes > 0) {
      children.add(
        _summaryChip(
          context,
          icon: Icons.schedule_rounded,
          label: 'Late',
          value: '${item.lateMinutes} min',
          color: Colors.orange,
        ),
      );
    }

    // Early Out
    if (item.earlyExitMinutes > 0) {
      children.add(
        _summaryChip(
          context,
          icon: Icons.logout_rounded,
          label: 'Early Out',
          value: '${item.earlyExitMinutes} min',
          color: colorScheme.error,
        ),
      );
    }

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: children,
    );
  }

  // ============================================================
  // SUMMARY CHIP
  // ============================================================

  Widget _summaryChip(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
        required Color color,
      }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),

          const SizedBox(width: 4),

          Text(
            '$label: ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            value,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORMAT MINUTES
  // ============================================================

  String _formatMinutes(int minutes) {
    if (minutes <= 0) {
      return '0 min';
    }

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) {
      return '$remainingMinutes min';
    }

    if (remainingMinutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${remainingMinutes}m';
  }

  // ============================================================
  // STATUS MESSAGE
  // ============================================================

  String _statusMessage() {
    switch (item.status) {
      case AttendanceReportStatus.dayOff:
        return 'Day Off';

      case AttendanceReportStatus.absent:
        return 'Absent';

      case AttendanceReportStatus.leave:
        return 'On Leave';

      case AttendanceReportStatus.holiday:
        return 'Holiday';

      case AttendanceReportStatus.earlyOut:
        return 'Early Out';

      case AttendanceReportStatus.present:
      case AttendanceReportStatus.late:
        return '-';
    }
  }

  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color _statusColor(
      BuildContext context,
      AttendanceReportStatus status,
      ) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (status) {
      case AttendanceReportStatus.present:
        return Colors.green;

      case AttendanceReportStatus.late:
        return colorScheme.error;

      case AttendanceReportStatus.earlyOut:
        return Colors.orange;

      case AttendanceReportStatus.absent:
        return colorScheme.error;

      case AttendanceReportStatus.leave:
        return Colors.orange;

      case AttendanceReportStatus.dayOff:
        return colorScheme.onSurfaceVariant;

      case AttendanceReportStatus.holiday:
        return colorScheme.primary;
    }
  }
}