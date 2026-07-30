import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class AttendanceAnalyticsCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceAnalyticsCard({
    super.key,
    required this.attendance,
  });

  Widget _item({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: color.withOpacity(.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          child: Column(
            children: [

              CircleAvatar(
                radius: 22,
                backgroundColor: color.withOpacity(.15),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _minutes(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;

    if (h == 0) {
      return "${m}m";
    }

    return "${h}h ${m}m";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Row(
              children: [

                Icon(Icons.analytics),

                SizedBox(width: 8),

                Text(
                  "Attendance Analytics",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            Row(
              children: [

                _item(
                  icon: Icons.work_history,
                  title: "Work",
                  value: _minutes(
                    attendance.workMinutes,
                  ),
                  color: Colors.green,
                ),

                const SizedBox(width: 12),

                _item(
                  icon: Icons.alarm,
                  title: "Late",
                  value: _minutes(
                    attendance.lateMinutes,
                  ),
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                _item(
                  icon: Icons.trending_up,
                  title: "Overtime",
                  value: _minutes(
                    attendance.overtimeMinutes,
                  ),
                  color: Colors.blue,
                ),

                const SizedBox(width: 12),

                _item(
                  icon: Icons.logout,
                  title: "Early Exit",
                  value: _minutes(
                    attendance.earlyExitMinutes,
                  ),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}