import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ------------------------------------------------------------
/// Flutter HRMS Pro
/// App Drawer
/// ------------------------------------------------------------

enum UserRole {
  superAdmin,
  companyAdmin,
  employee,
}

class DrawerItem {
  final String title;
  final IconData icon;
  final String route;
  final List<UserRole> roles;

  const DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.roles,
  });
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    this.role = UserRole.employee,
  });

  final UserRole role;

  static const List<DrawerItem> _items = [
    DrawerItem(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: '/dashboard',
      roles: [
        UserRole.superAdmin,
        UserRole.companyAdmin,
        UserRole.employee,
      ],
    ),

    DrawerItem(
      title: 'Companies',
      icon: Icons.business_outlined,
      route: '/companies',
      roles: [
        UserRole.superAdmin,
      ],
    ),

    DrawerItem(
      title: 'Employees',
      icon: Icons.people_outline,
      route: '/employees',
      roles: [
        UserRole.superAdmin,
        UserRole.companyAdmin,
      ],
    ),

    DrawerItem(
      title: 'Attendance',
      icon: Icons.fingerprint,
      route: '/attendance',
      roles: [
        UserRole.superAdmin,
        UserRole.companyAdmin,
        UserRole.employee,
      ],
    ),

    DrawerItem(
      title: 'Leave',
      icon: Icons.event_note_outlined,
      route: '/leave',
      roles: [
        UserRole.superAdmin,
        UserRole.companyAdmin,
        UserRole.employee,
      ],
    ),

    DrawerItem(
      title: 'Tasks',
      icon: Icons.task_alt,
      route: '/tasks',
      roles: [
        UserRole.superAdmin,
        UserRole.companyAdmin,
        UserRole.employee,
      ],
    ),

    DrawerItem(
      title: 'Profile',
      icon: Icons.person_outline,
      route: '/profile',
      roles: [
        UserRole.superAdmin,
        UserRole.companyAdmin,
        UserRole.employee,
      ],
    ),

    DrawerItem(
      title: 'Settings',
      icon: Icons.settings_outlined,
      route: '/settings',
      roles: [
        UserRole.superAdmin,
        UserRole.companyAdmin,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final menus =
    _items.where((item) => item.roles.contains(role)).toList();

    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),

          const CircleAvatar(
            radius: 34,
            child: Icon(Icons.business, size: 34),
          ),

          const SizedBox(height: 12),

          const Text(
            'Flutter HRMS Pro',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            role.name,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              itemCount: menus.length,
              itemBuilder: (_, index) {
                final item = menus[index];

                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  onTap: () {
                    context.go(item.route);
                  },
                );
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // TODO
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}