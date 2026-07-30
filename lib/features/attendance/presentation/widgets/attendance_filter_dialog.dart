import 'package:flutter/material.dart';

class AttendanceFilterDialog extends StatefulWidget {
  final String? selectedStatus;

  const AttendanceFilterDialog({
    super.key,
    this.selectedStatus,
  });

  @override
  State<AttendanceFilterDialog> createState() =>
      _AttendanceFilterDialogState();
}

class _AttendanceFilterDialogState
    extends State<AttendanceFilterDialog> {
  late String? status;

  @override
  void initState() {
    super.initState();
    status = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Attendance'),
      content: DropdownButtonFormField<String>(
        value: status,
        decoration: const InputDecoration(
          labelText: 'Status',
        ),
        items: const [
          DropdownMenuItem(
            value: 'PRESENT',
            child: Text('Present'),
          ),
          DropdownMenuItem(
            value: 'ABSENT',
            child: Text('Absent'),
          ),
          DropdownMenuItem(
            value: 'LATE',
            child: Text('Late'),
          ),
          DropdownMenuItem(
            value: 'LEAVE',
            child: Text('Leave'),
          ),
          DropdownMenuItem(
            value: 'HALF_DAY',
            child: Text('Half Day'),
          ),
          DropdownMenuItem(
            value: 'HOLIDAY',
            child: Text('Holiday'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            status = value;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, status);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}