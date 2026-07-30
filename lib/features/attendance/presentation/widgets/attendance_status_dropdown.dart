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

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(
        labelText: 'Attendance Status',
        border: OutlineInputBorder(),
      ),
      items: statuses
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}