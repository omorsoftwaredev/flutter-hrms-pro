/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Statistics
///
/// Version : 0.7.0
/// ===============================================================

import 'package:flutter/material.dart';

class DashboardStatistics extends StatelessWidget {
  final int companies;
  final int departments;
  final int employees;

  const DashboardStatistics({
    super.key,
    required this.companies,
    required this.departments,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "System Statistics",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.business),
              title: const Text("Companies"),
              trailing: Text("$companies"),
            ),

            ListTile(
              leading: const Icon(Icons.account_tree),
              title: const Text("Departments"),
              trailing: Text("$departments"),
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Employees"),
              trailing: Text("$employees"),
            ),
          ],
        ),
      ),
    );
  }
}