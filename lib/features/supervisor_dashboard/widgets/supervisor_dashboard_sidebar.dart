// ===============================================================
// Flutter HRMS Pro
// Company Dashboard Sidebar
//
// Version : 2.4.0
//
// Updated:
// - Added Manage Supervisor Departments menu
// - Existing menus preserved
// - Existing routes preserved
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/route_paths.dart';

class SupervisorDashboardSidebar extends ConsumerWidget {
  const SupervisorDashboardSidebar({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final CurrentUser? user =
    ref.watch(currentUserProvider);

    // =========================================================
    // USER LOADING
    // =========================================================

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
            // ===================================================
            // USER HEADER
            // ===================================================

            _buildUserHeader(user),

            // ===================================================
            // MENU
            // ===================================================

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                children: [

                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Theme Settings',
                    subtitle: 'Application Theme settings',
                    onTap: () {
                      Navigator.pop(context);

                      context.push(
                        RoutePaths.themeSettings,
                      );
                    },
                  ),

                  // =================================================
                  // DEPARTMENTS
                  // =================================================

                  _buildMenuItem(
                    context,
                    icon: Icons.apartment_outlined,
                    title: 'Attendance',
                    subtitle: 'Attendance Report',
                    onTap: () {
                      Navigator.pop(context);

                      final supervisorEmployeeId = user.employeeId;

                      if (supervisorEmployeeId.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Supervisor Employee ID not available.',
                            ),
                          ),
                        );
                        return;
                      }

                      context.pushNamed(
                        'supervisorEmployeeAttendanceReport',
                        queryParameters: {
                          'supervisorEmployeeId': supervisorEmployeeId,
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // =====================================================
            // LOGOUT DIVIDER
            // =====================================================

            const Divider(
              height: 1,
            ),

            // =====================================================
            // LOGOUT
            // =====================================================

            ListTile(
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.08),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 21,
                ),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Sign out from your account',
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);

                await ref
                    .read(authRepositoryProvider)
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

  // =============================================================
  // USER HEADER
  // =============================================================

  Widget _buildUserHeader(
      CurrentUser user,
      ) {
    final String displayName =
    user.displayName.trim().isNotEmpty
        ? user.displayName
        : user.loginName;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        17,
        20,
        17,
        17,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =====================================================
          // PROFILE
          // =====================================================

          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    displayName.isEmpty
                        ? '?'
                        : displayName[0]
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      user.loginUser,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          // =====================================================
          // LOGIN INFORMATION TITLE
          // =====================================================

          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: Colors.white,
                size: 17,
              ),
              const SizedBox(
                width: 7,
              ),
              const Text(
                'Login Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 11,
          ),

          // =====================================================
          // LOGIN NAME
          // =====================================================

          _infoRow(
            icon: Icons.person_outline,
            label: 'Login Name',
            value: user.loginName,
          ),

          // =====================================================
          // LOGIN USER
          // =====================================================

          _infoRow(
            icon: Icons.account_circle_outlined,
            label: 'Login User',
            value: user.loginUser,
          ),

          // =====================================================
          // ROLE
          // =====================================================

          _infoRow(
            icon:
            Icons.admin_panel_settings_outlined,
            label: 'Role',
            value: user.role.name,
          ),

          // =====================================================
          // COMPANY
          // =====================================================

          if (user.companyName != null &&
              user.companyName!
                  .trim()
                  .isNotEmpty)
            _infoRow(
              icon: Icons.business_outlined,
              label: 'Company',
              value: user.companyName!,
            ),

          const SizedBox(
            height: 9,
          ),

          // =====================================================
          // PERMISSIONS
          // =====================================================

          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color:
              Colors.white.withOpacity(.12),
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.security_outlined,
                  color: Colors.white,
                  size: 16,
                ),

                const SizedBox(
                  width: 7,
                ),

                Expanded(
                  child: Text(
                    '${user.permissions.length} permissions available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),

                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // INFO ROW
  // =============================================================

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 6,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color:
            Colors.white.withOpacity(.85),
            size: 15,
          ),

          const SizedBox(
            width: 7,
          ),

          SizedBox(
            width: 82,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white
                    .withOpacity(.72),
                fontSize: 10.5,
              ),
            ),
          ),

          const Text(
            ':',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),

          const SizedBox(
            width: 5,
          ),

          Expanded(
            child: Text(
              value.trim().isEmpty
                  ? '-'
                  : value,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // MENU ITEM
  // =============================================================

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),

      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3)
              .withOpacity(.08),
          borderRadius:
          BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color:
          const Color(0xFF2196F3),
          size: 21,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight:
          FontWeight.w600,
        ),
      ),

      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11,
        ),
      ),

      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
      ),

      onTap: onTap,
    );
  }
}