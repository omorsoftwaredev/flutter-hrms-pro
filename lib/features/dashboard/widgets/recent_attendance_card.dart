/// ===============================================================
/// Flutter HRMS Pro
/// Recent Attendance Card
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class RecentAttendanceCard extends StatelessWidget {
  const RecentAttendanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.fingerprint),
        ),
        title: const Text("Today's Attendance"),
        subtitle: const Text(
          "Recent attendance information will appear here.",
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}