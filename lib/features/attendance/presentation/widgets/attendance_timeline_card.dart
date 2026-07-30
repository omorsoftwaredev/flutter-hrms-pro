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
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _item(
              context,
              Icons.login,
              "Check In",
              _format(checkInTime),
            ),

            const Divider(),

            _item(
              context,
              Icons.logout,
              "Check Out",
              _format(checkOutTime),
            ),

            const Divider(),

            _item(
              context,
              Icons.timer,
              "Working Time",
              "$workMinutes Minutes",
            ),

            const Divider(),

            _item(
              context,
              Icons.schedule,
              "Overtime",
              "$overtimeMinutes Minutes",
            ),

            const Divider(),

            _item(
              context,
              Icons.warning_amber_rounded,
              "Late",
              "$lateMinutes Minutes",
            ),

            const Divider(),

            _item(
              context,
              Icons.exit_to_app,
              "Early Exit",
              "$earlyExitMinutes Minutes",
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context,
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [

        CircleAvatar(
          radius: 18,
          child: Icon(icon, size: 18),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium,
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
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