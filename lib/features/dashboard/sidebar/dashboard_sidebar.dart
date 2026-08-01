/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Sidebar
///
/// Version : 0.8.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../menus/dashboard_menu_factory.dart';

class DashboardSidebar extends ConsumerWidget {
  const DashboardSidebar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CurrentUser? user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Drawer(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final menus = DashboardMenuFactory.getMenus(user);

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
            // Menus
            // =====================================================

            Expanded(
              child: ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];

                  return ListTile(
                    leading: Icon(menu.icon),
                    title: Text(menu.title),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(menu.route);
                    },
                  );
                },
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

                try {
                  // Supabase Logout
                  await ref
                      .read(authRepositoryProvider)
                      .logout();

                  // Clear Current User
                  ref
                      .read(currentUserProvider.notifier)
                      .logout();

                  if (context.mounted) {
                    context.go('/login');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Logout failed: $e',
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}