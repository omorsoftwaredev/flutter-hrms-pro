import 'package:flutter/material.dart';

import '../../domain/entities/attendance_entity.dart';

class DeviceInfoCard extends StatelessWidget {
  final AttendanceEntity attendance;

  const DeviceInfoCard({
    super.key,
    required this.attendance,
  });

  Widget _row(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [

          Icon(
            icon,
            size: 20,
            color: Colors.blue,
          ),

          const SizedBox(width: 12),

          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Text(": "),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
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

                Icon(Icons.phone_android),

                SizedBox(width: 8),

                Text(
                  "Device Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            _row(
              Icons.smartphone,
              "Device",
              attendance.deviceName ?? "--",
            ),

            _row(
              Icons.qr_code,
              "Device ID",
              attendance.deviceId ?? "--",
            ),

            _row(
              Icons.public,
              "IP Address",
              attendance.ipAddress ?? "--",
            ),
          ],
        ),
      ),
    );
  }
}