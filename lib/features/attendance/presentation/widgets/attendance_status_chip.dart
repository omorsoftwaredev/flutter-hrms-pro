import 'package:flutter/material.dart';

class AttendanceStatusChip extends StatelessWidget {
  final String status;

  const AttendanceStatusChip({
    super.key,
    required this.status,
  });

  Color get color {
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return Colors.green;

      case 'ABSENT':
        return Colors.red;

      case 'LATE':
        return Colors.orange;

      case 'LEAVE':
        return Colors.blue;

      case 'HALF_DAY':
        return Colors.deepOrange;

      case 'HOLIDAY':
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return Icons.check_circle;

      case 'ABSENT':
        return Icons.cancel;

      case 'LATE':
        return Icons.access_time;

      case 'LEAVE':
        return Icons.event_busy;

      case 'HALF_DAY':
        return Icons.timelapse;

      case 'HOLIDAY':
        return Icons.beach_access;

      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        icon,
        color: Colors.white,
        size: 18,
      ),
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color,
    );
  }
}