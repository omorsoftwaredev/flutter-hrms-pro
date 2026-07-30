import 'package:flutter/material.dart';

class AttendanceRemarksCard extends StatelessWidget {
  final String? remarks;

  const AttendanceRemarksCard({
    super.key,
    this.remarks,
  });

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
                Icon(Icons.sticky_note_2),
                SizedBox(width: 8),
                Text(
                  "Remarks",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              remarks?.trim().isEmpty ?? true
                  ? "No Remarks"
                  : remarks!,
            ),
          ],
        ),
      ),
    );
  }
}