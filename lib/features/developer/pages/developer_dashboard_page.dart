/// ===============================================================
/// Flutter HRMS Pro
/// Developer Dashboard
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';

import '../../dashboard/sidebar/dashboard_sidebar.dart';
import '../../dashboard/widgets/dashboard_app_bar.dart';

class DeveloperDashboardPage extends StatelessWidget {
  const DeveloperDashboardPage({
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
      drawer: const DashboardSidebar(),

      appBar: const DashboardAppBar(
        title: "Developer Dashboard",
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text(
            "Welcome Developer",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Flutter HRMS Pro Root Control Panel",
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

          _buildCard(
            icon: Icons.apartment,
            title: "Employees",
            value: "0",
            color: Colors.orange,
          ),

          _buildCard(
            icon: Icons.admin_panel_settings,
            title: "Super Admin",
            value: "0",
            color: Colors.red,
          ),

          const SizedBox(height: 20),

          const Text(
            "Developer Menu",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _buildMenu(
            context,
            icon: Icons.add_business,
            title: "Create Company",
            onTap: () {
              // context.push(...)
            },
          ),

          _buildMenu(
            context,
            icon: Icons.business,
            title: "Company List",
            onTap: () {},
          ),

          _buildMenu(
            context,
            icon: Icons.manage_accounts,
            title: "Company Accounts",
            onTap: () {},
          ),

          _buildMenu(
            context,
            icon: Icons.analytics,
            title: "Reports",
            onTap: () {},
          ),

          _buildMenu(
            context,
            icon: Icons.settings,
            title: "System Settings",
            onTap: () {},
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}