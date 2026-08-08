/// ===============================================================
/// Flutter HRMS Pro
/// Company Dashboard
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_paths.dart';
import '../../dashboard/widgets/dashboard_app_bar.dart';
import '../widgets/employee_dashboard_sidebar.dart';

class EmployeeDashboardPage extends StatelessWidget {
  const EmployeeDashboardPage({
    super.key,
  });

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(.12),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(title),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const EmployeeDashboardSidebar(),

      appBar: const DashboardAppBar(
        title: "Employee Dashboard",
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text(
            "Welcome Employee",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "HRMS Pro Employee Dashboard Panel",
          ),

          const SizedBox(height: 25),

          _buildCard(
            icon: Icons.business,
            title: "Total Attendance",
            value: "0",
            color: Colors.blue,
          ),

          _buildCard(
            icon: Icons.people,
            title: "Total Late",
            value: "0",
            color: Colors.green,
          ),

          const SizedBox(height: 20),

          const Text(
            "Employee Menu",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _buildMenu(
            context,
            icon: Icons.apartment_outlined,
            title: "Dashboard",
            onTap: () {
              context.push(RoutePaths.departments);
            },
          ),

          _buildMenu(
            context,
            icon: Icons.badge_outlined,
            title: "Attendance",
            onTap: () {
              context.push(RoutePaths.designations);
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}