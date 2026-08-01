/// ===============================================================
/// Flutter HRMS Pro
/// Employee Status Card
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class EmployeeStatusCard extends StatelessWidget {
  final int total;
  final int active;
  final int inactive;

  const EmployeeStatusCard({
    super.key,
    required this.total,
    required this.active,
    required this.inactive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.people),
        ),
        title: const Text("Employees"),
        subtitle: Text(
          "Active : $active\nInactive : $inactive",
        ),
        trailing: Text(
          "$total",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}