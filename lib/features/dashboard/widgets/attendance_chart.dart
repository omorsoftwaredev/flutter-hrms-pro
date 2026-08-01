/// ===============================================================
/// Flutter HRMS Pro
/// Attendance Chart
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class AttendanceChart extends StatelessWidget {
  const AttendanceChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 250,
        child: Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: const [

              Icon(
                Icons.bar_chart,
                size: 60,
              ),

              SizedBox(height: 12),

              Text(
                "Attendance Chart",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 6),

              Text(
                "Coming Soon",
              ),
            ],
          ),
        ),
      ),
    );
  }
}