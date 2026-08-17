// ===============================================================
// HRMS Pro
// Employee Dashboard Sidebar
//
// Version : 2.3.0
//
// UI Improvements:
// - Theme aware
// - Responsive
// - Light / Dark mode support
// - Desktop / Tablet / Mobile friendly
//
// Functionality: UNCHANGED
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/route_paths.dart';

class EmployeeDashboardSidebar extends ConsumerWidget {
  const EmployeeDashboardSidebar({super.key});

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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      width: _drawerWidth(context),
      backgroundColor: colorScheme.surface,
      elevation: 8,
      child: SafeArea(
        child: Column(
          children: [
            // ===================================================
            // LOGIN INFORMATION
            // ===================================================
            _buildUserHeader(
              context,
              user,
              colorScheme,
              isDark,
            ),

            // ===================================================
            // MENU
            // ===================================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.palette_outlined,
                    title: 'Theme & Appearance',
                    subtitle:
                    'Customize app theme and appearance',
                    onTap: () {
                      Navigator.pop(context);

                      context.push(
                        RoutePaths.themeSettings,
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    subtitle: 'Employee Dashboard',
                    onTap: () {
                      Navigator.pop(context);

                      // context.push(RoutePaths.departments);
                    },
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.fingerprint,
                    title: 'Mobile Attendance',
                    subtitle: 'Check In / Check Out',
                    onTap: () {
                      Navigator.pop(context);

                      context.push(RoutePaths.mobileAttendance);
                    },
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.assessment_outlined,
                    title: 'Attendance Report',
                    subtitle: 'View your attendance report',
                    onTap: () {
                      Navigator.pop(context);

                      if (user.employeeId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
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
                            '?employeeId=${user.employeeId}',
                      );
                    },
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.lock_reset_outlined,
                    title: 'Change Password',
                    subtitle: 'Keep your account secure',
                    onTap: () {
                      Navigator.pop(context);

                      context.push(RoutePaths.changePassword);
                    },
                  ),
                ],
              ),
            ),

            // ===================================================
            // LOGOUT
            // ===================================================
            Divider(
              height: 1,
              color: colorScheme.outline.withOpacity(.18),
            ),

            _buildLogoutItem(
              context,
              ref,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // RESPONSIVE DRAWER WIDTH
  // =============================================================

  double _drawerWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    // Mobile
    if (width < 600) {
      return width * .86;
    }

    // Tablet
    if (width < 1000) {
      return 360;
    }

    // Desktop
    return 380;
  }

  // =============================================================
  // USER HEADER
  // =============================================================

  Widget _buildUserHeader(
      BuildContext context,
      CurrentUser user,
      ColorScheme colorScheme,
      bool isDark,
      ) {
    final primary = colorScheme.primary;

    final displayName = user.displayName.trim().isEmpty
        ? 'Employee'
        : user.displayName.trim();

    final initial = displayName.isEmpty
        ? '?'
        : displayName[0].toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        22,
        18,
        18,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            Color.alphaBlend(
              Colors.white.withOpacity(
                isDark ? .03 : .10,
              ),
              primary,
            ),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(
              isDark ? .18 : .16,
            ),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // PROFILE
          // =====================================================

          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.95),
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: primary,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      user.loginUser.isEmpty
                          ? 'Employee Account'
                          : user.loginUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.82),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =====================================================
          // LOGIN INFORMATION TITLE
          // =====================================================

          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.13),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: Colors.white,
                  size: 16,
                ),
              ),

              const SizedBox(width: 8),

              const Text(
                'Login Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

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
            icon: Icons.admin_panel_settings_outlined,
            label: 'Role',
            value: user.role.name,
          ),

          // =====================================================
          // EMPLOYEE
          // =====================================================

          if (user.employeeName != null &&
              user.employeeName!.trim().isNotEmpty)
            _infoRow(
              icon: Icons.badge_outlined,
              label: 'Employee',
              value: user.employeeName!,
            ),

          // =====================================================
          // COMPANY
          // =====================================================

          if (user.companyName != null &&
              user.companyName!.trim().isNotEmpty)
            _infoRow(
              icon: Icons.business_outlined,
              label: 'Company',
              value: user.companyName!,
            )
          else if (user.companyId.isNotEmpty)
            _infoRow(
              icon: Icons.business_outlined,
              label: 'Company ID',
              value: user.companyId,
            ),

          // =====================================================
          // DEPARTMENT
          // =====================================================

          if (user.departmentName != null &&
              user.departmentName!.trim().isNotEmpty)
            _infoRow(
              icon: Icons.account_tree_outlined,
              label: 'Department',
              value: user.departmentName!,
            ),

          // =====================================================
          // DESIGNATION
          // =====================================================

          if (user.designationName != null &&
              user.designationName!.trim().isNotEmpty)
            _infoRow(
              icon: Icons.work_outline,
              label: 'Designation',
              value: user.designationName!,
            ),

          const SizedBox(height: 10),

          // =====================================================
          // PERMISSION
          // =====================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(.10),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.security_outlined,
                  color: Colors.white,
                  size: 17,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    '${user.permissions.length} permissions available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 16,
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
      padding: const EdgeInsets.only(
        bottom: 7,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(.85),
            size: 15,
          ),

          const SizedBox(width: 7),

          SizedBox(
            width: 82,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(.70),
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

          const SizedBox(width: 5),

          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              children: [
                // =================================================
                // ICON
                // =================================================

                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withOpacity(.09),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 13),

                // =================================================
                // TEXT
                // =================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                          colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme
                              .onSurface
                              .withOpacity(.58),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.chevron_right_rounded,
                  size: 21,
                  color: colorScheme.onSurface
                      .withOpacity(.38),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // LOGOUT
  // =============================================================

  Widget _buildLogoutItem(
      BuildContext context,
      WidgetRef ref,
      ColorScheme colorScheme,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        8,
        10,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.error
                        .withOpacity(.09),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: colorScheme.error,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: colorScheme.error,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Sign out from your account',
                        style: TextStyle(
                          color: colorScheme.onSurface
                              .withOpacity(.55),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  size: 21,
                  color: colorScheme.error
                      .withOpacity(.45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}