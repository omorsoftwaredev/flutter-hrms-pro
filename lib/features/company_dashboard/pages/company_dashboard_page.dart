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
import '../widgets/company_dashboard_sidebar.dart';

class CompanyDashboardPage extends StatelessWidget {
  const CompanyDashboardPage({
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
      drawer: const CompanyDashboardSidebar(),

      appBar: const DashboardAppBar(
        title: "Company Dashboard",
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text(
            "Welcome Company",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "HRMS Pro Root Control Panel",
          ),

          const SizedBox(height: 25),

          _buildCard(
            icon: Icons.business,
            title: "Total Companies",
            value: "0",
            color: Colors.blue,
          ),

          _buildCard(
            icon: Icons.people,
            title: "Company Accounts",
            value: "0",
            color: Colors.green,
          ),

          const SizedBox(height: 20),

          const Text(
            "Company Menu",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _buildMenu(
            context,
            icon: Icons.apartment_outlined,
            title: "Departments",
            onTap: () {
              context.push(RoutePaths.departments);
            },
          ),

          _buildMenu(
            context,
            icon: Icons.badge_outlined,
            title: "Designations",
            onTap: () {
              context.push(RoutePaths.designations);
            },
          ),

          _buildMenu(
            context,
            icon: Icons.schedule_outlined,
            title: "Shifts",
            onTap: () {
              context.push(RoutePaths.shifts);
            },
          ),

          _buildMenu(
            context,
            icon: Icons.admin_panel_settings_outlined,
            title: "Roles",
            onTap: () {
              context.push(RoutePaths.roles);
            },
          ),

          _buildMenu(
            context,
            icon: Icons.security_outlined,
            title: "Role Permissions",
            onTap: () {
              context.push(RoutePaths.rolePermissions);
            },
          ),

          _buildMenu(
            context,
            icon: Icons.people_outline,
            title: "Employees",
            onTap: () {
              context.push(RoutePaths.employees);
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}