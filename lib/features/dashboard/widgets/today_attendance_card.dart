/// ===============================================================
/// Flutter HRMS Pro
/// Today Attendance Card
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class TodayAttendanceCard extends StatelessWidget {
  final int present;
  final int absent;
  final int late;

  const TodayAttendanceCard({
    super.key,
    required this.present,
    required this.absent,
    required this.late,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Today's Attendance",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: [

                _item("Present", present),

                _item("Absent", absent),

                _item("Late", late),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, int value) {
    return Column(
      children: [
        Text(
          "$value",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title),
      ],
    );
  }
}