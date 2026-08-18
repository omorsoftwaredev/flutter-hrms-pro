import 'package:flutter/material.dart';

class AttendanceStatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const AttendanceStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const statuses = [
    'PRESENT',
    'ABSENT',
    'LATE',
    'LEAVE',
    'HALF_DAY',
    'HOLIDAY',
  ];

  Color _statusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (status) {
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

  IconData _statusIcon(String status) {
    switch (status) {
      case 'PRESENT':
        return Icons.check_circle_outline;
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

    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: InputDecoration(
        labelText: 'Attendance Status',
        hintText: 'Select attendance status',
        prefixIcon: Icon(
          Icons.fact_check_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
      items: statuses.map((status) {
        final statusColor = _statusColor(context, status);

        return DropdownMenuItem<String>(
          value: status,
          child: Row(
            children: [
              Icon(
                _statusIcon(status),
                size: 20,
                color: statusColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  status,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}