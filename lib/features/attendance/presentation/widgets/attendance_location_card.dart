import 'package:flutter/material.dart';

class AttendanceLocationCard extends StatelessWidget {
  final String title;
  final double? latitude;
  final double? longitude;
  final String? address;
  final IconData icon;

  const AttendanceLocationCard({
    super.key,
    required this.title,
    required this.latitude,
    required this.longitude,
    required this.icon,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              child: Icon(icon),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    address ?? "--",
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Latitude : ${latitude?.toStringAsFixed(6) ?? "--"}",
                  ),

                  Text(
                    "Longitude : ${longitude?.toStringAsFixed(6) ?? "--"}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}