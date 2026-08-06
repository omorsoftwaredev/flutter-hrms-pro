// ===============================================================
// Flutter HRMS Pro
// Developer Sidebar
//
// Version : 2.0.0
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/route_paths.dart';

class CompanyDashboardSidebar extends ConsumerWidget {
  const CompanyDashboardSidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CurrentUser? user =
    ref.watch(currentUserProvider);

    if (user == null) {
      return const Drawer(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // Header
            // =====================================================

            UserAccountsDrawerHeader(
              accountName: Text(user.fullName),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  user.fullName.isEmpty
                      ? '?'
                      : user.fullName[0].toUpperCase(),
                ),
              ),
            ),

            // =====================================================
            // Menu
            // =====================================================

            Expanded(
              child: ListView(
                children: [

                  // =====================================================
// Organization Setup
// =====================================================

                  ListTile(
                    leading: const Icon(Icons.apartment_outlined),
                    title: const Text('Departments'),
                    subtitle: const Text('Department Management'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.departments);
                    },

                  ),

                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Designations'),
                    subtitle: const Text('Designation Management'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.designations);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.schedule_outlined),
                    title: const Text('Shifts'),
                    subtitle: const Text('Shift Management'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.shifts);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined),
                    title: const Text('Roles'),
                    subtitle: const Text('Role Management'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.roles);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.security_outlined),
                    title: const Text('Role Permissions'),
                    subtitle: const Text('Permission Management'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.rolePermissions);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.people_outline),
                    title: const Text('Employees'),
                    subtitle: const Text('Employee Management'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.employees);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people_outline),
                    title: const Text('Employee Accounts'),
                    subtitle: const Text('Employee Accounts Management'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RoutePaths.employeesAccounts);
                    },
                  ),


                ],
              ),
            ),

            const Divider(height: 1),

            // =====================================================
            // Logout
            // =====================================================

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);

                await ref
                    .read(authRepositoryProvider)
                    .logout();

                ref
                    .read(currentUserProvider.notifier)
                    .logout();

                if (context.mounted) {
                  context.go(RoutePaths.login);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}