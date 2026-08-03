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

class DeveloperSidebar extends ConsumerWidget {
  const DeveloperSidebar({
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

                  // Company Management

                  ListTile(
                    leading: const Icon(Icons.business_outlined),
                    title: const Text('Company Management'),
                    subtitle: const Text(
                      'Company Setup & Maintenance',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(
                        RoutePaths.companies,
                      );
                    },
                  ),

                  // Company Accounts

                  ListTile(
                    leading: const Icon(Icons.manage_accounts_outlined),
                    title: const Text('Company Accounts'),
                    subtitle: const Text(
                      'Login & Account Management',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(
                        RoutePaths.companyAccounts,
                      );
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