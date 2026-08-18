import 'package:flutter/material.dart';

class AttendanceStatusChip extends StatelessWidget {
  final String status;

  const AttendanceStatusChip({
    super.key,
    required this.status,
  });

  Color _color(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (status.toUpperCase()) {
      case 'PRESENT':
        return Colors.green;

      case 'ABSENT':
        return colorScheme.error;

      case 'LATE':
        return Colors.orange;

      case 'LEAVE':
        return colorScheme.primary;

      case 'HALF_DAY':
        return Colors.deepOrange;

      case 'HOLIDAY':
        return Colors.purple;

      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  IconData _icon() {
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return Icons.check_circle_outline_rounded;

      case 'ABSENT':
        return Icons.cancel_outlined;

      case 'LATE':
        return Icons.access_time_rounded;

      case 'LEAVE':
        return Icons.event_busy_outlined;

      case 'HALF_DAY':
        return Icons.timelapse_rounded;

      case 'HOLIDAY':
        return Icons.beach_access_outlined;

      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final width = MediaQuery.sizeOf(context).width;

    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    final double horizontalPadding = isDesktop
        ? 12
        : isTablet
        ? 10
        : 8;

    final double verticalPadding = isDesktop
        ? 7
        : isTablet
        ? 6
        : 5;

    final double iconSize = isDesktop
        ? 17
        : isTablet
        ? 16
        : 15;

    final color = _color(context);

    return Container(
      constraints: const BoxConstraints(
        minHeight: 30,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon(),
            color: Colors.white,
            size: iconSize,
          ),

          const SizedBox(width: 5),

          Flexible(
            child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: .1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}