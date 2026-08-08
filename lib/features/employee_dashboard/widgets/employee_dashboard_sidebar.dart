// ===============================================================
// HRMS Pro
// Employee Dashboard Sidebar
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

class EmployeeDashboardSidebar extends ConsumerWidget {
  const EmployeeDashboardSidebar({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
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
              accountName: Text(
                user.fullName,
              ),
              accountEmail: Text(
                user.email,
              ),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  user.fullName.isEmpty
                      ? '?'
                      : user.fullName[0]
                      .toUpperCase(),
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
                  // Dashboard
                  // =====================================================

                  ListTile(
                    leading: const Icon(
                      Icons.apartment_outlined,
                    ),
                    title: const Text(
                      'Dashboard',
                    ),
                    subtitle: const Text(
                      'Dashboard Details',
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      context.push(
                        RoutePaths.departments,
                      );
                    },
                  ),

                  // =====================================================
                  // Mobile Attendance
                  // =====================================================

                  ListTile(
                    leading: const Icon(
                      Icons.badge_outlined,
                    ),
                    title: const Text(
                      'Mobile Attendance',
                    ),
                    subtitle: const Text(
                      'Attendance Management',
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      context.push(
                        RoutePaths.mobileAttendance,
                      );
                    },
                  ),

                  // =====================================================
                  // Employee Attendance Report
                  // =====================================================

                  ListTile(
                    leading: const Icon(
                      Icons.assessment_outlined,
                    ),
                    title: const Text(
                      'Attendance Report',
                    ),
                    subtitle: const Text(
                      'View your attendance report',
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      final employeeId =
                          user.employeeId;

                      if (employeeId == null ||
                          employeeId.isEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Employee ID not found.',
                            ),
                          ),
                        );

                        return;
                      }

                      context.push(
                        '${RoutePaths.employeeAttendanceReport}'
                            '?employeeId=$employeeId',
                      );
                    },
                  ),

                  // =====================================================
                  // Change Password
                  // =====================================================

                  ListTile(
                    leading: const Icon(
                      Icons.lock_reset_outlined,
                    ),
                    title: const Text(
                      'Change Password',
                    ),
                    subtitle: const Text(
                      'Keep your account secure',
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      context.push(
                        RoutePaths.changePassword,
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(
              height: 1,
            ),

            // =====================================================
            // Logout
            // =====================================================

            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text(
                'Logout',
              ),
              onTap: () async {
                Navigator.pop(context);

                await ref
                    .read(
                  authRepositoryProvider,
                )
                    .logout();

                ref
                    .read(
                  currentUserProvider.notifier,
                )
                    .logout();

                if (context.mounted) {
                  context.go(
                    RoutePaths.login,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}