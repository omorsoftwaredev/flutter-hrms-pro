import 'package:flutter/material.dart';

class AttendanceTimelineCard extends StatelessWidget {
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final int workMinutes;
  final int overtimeMinutes;
  final int lateMinutes;
  final int earlyExitMinutes;

  const AttendanceTimelineCard({
    super.key,
    this.checkInTime,
    this.checkOutTime,
    required this.workMinutes,
    required this.overtimeMinutes,
    required this.lateMinutes,
    required this.earlyExitMinutes,
  });

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
        ? 20
        : 16;

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
            _item(
              context,
              icon: Icons.login_rounded,
              title: "Check In",
              value: _format(checkInTime),
            ),

            const Divider(height: 24),

            _item(
              context,
              icon: Icons.logout_rounded,
              title: "Check Out",
              value: _format(checkOutTime),
            ),

            const Divider(height: 24),

            _item(
              context,
              icon: Icons.timer_outlined,
              title: "Working Time",
              value: "$workMinutes Minutes",
            ),

            const Divider(height: 24),

            _item(
              context,
              icon: Icons.schedule_rounded,
              title: "Overtime",
              value: "$overtimeMinutes Minutes",
            ),

            const Divider(height: 24),

            _item(
              context,
              icon: Icons.warning_amber_rounded,
              title: "Late",
              value: "$lateMinutes Minutes",
            ),

            const Divider(height: 24),

            _item(
              context,
              icon: Icons.exit_to_app_rounded,
              title: "Early Exit",
              value: "$earlyExitMinutes Minutes",
            ),
          ],
        ),
      ),
    );
  }

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

    final double iconContainerSize = isDesktop
        ? 42
        : isTablet
        ? 40
        : 38;

    final double iconSize = isDesktop
        ? 20
        : 18;

    final double titleSize = isDesktop
        ? 15
        : 14;

    final double valueSize = isDesktop
        ? 15
        : 14;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // =========================================================
        // ICON
        // =========================================================
        Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(
              alpha: 0.10,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(width: 14),

        // =========================================================
        // TITLE
        // =========================================================
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: titleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // =========================================================
        // VALUE
        // =========================================================
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: valueSize,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  String _format(DateTime? dateTime) {
    if (dateTime == null) return "--";

    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');

    return "$h:$m";
  }
}