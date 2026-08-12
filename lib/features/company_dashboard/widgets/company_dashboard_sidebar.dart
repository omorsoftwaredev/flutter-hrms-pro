// ===============================================================
// Flutter HRMS Pro
// Company Dashboard Sidebar
//
// Version : 2.6.0
//
// Updated:
// - Accordion style parent menu
// - Only one parent group opens at a time
// - Previous parent automatically closes
// - Cleaner child menu separation
// - Meaningful single-line menu labels
// - Existing routes preserved
// - Existing logout functionality preserved
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/route_paths.dart';

class CompanyDashboardSidebar extends ConsumerStatefulWidget {
  const CompanyDashboardSidebar({
    super.key,
  });

  @override
  ConsumerState<CompanyDashboardSidebar> createState() =>
      _CompanyDashboardSidebarState();
}

class _CompanyDashboardSidebarState
    extends ConsumerState<CompanyDashboardSidebar> {
  // =============================================================
  // CURRENTLY OPEN GROUP
  // =============================================================
  //
  // Only ONE parent group can remain open at a time.
  //
  // Example:
  // Organization open
  //       ↓
  // People click
  //       ↓
  // Organization closes
  // People opens
  //
  // =============================================================

  String? _expandedGroup = 'Organization';

  // =============================================================
  // TOGGLE GROUP
  // =============================================================

  void _toggleGroup(String group) {
    setState(() {
      // Same group click করলে close হবে
      if (_expandedGroup == group) {
        _expandedGroup = null;
      }

      // অন্য group click করলে আগেরটা close হয়ে
      // নতুন group open হবে
      else {
        _expandedGroup = group;
      }
    });
  }

  // =============================================================
  // CLOSE DRAWER + NAVIGATE
  // =============================================================

  void _navigate(
      BuildContext context,
      String route,
      ) {
    Navigator.pop(context);
    context.push(route);
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final CurrentUser? user = ref.watch(
      currentUserProvider,
    );

    // ===========================================================
    // USER LOADING
    // ===========================================================

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
                padding: const EdgeInsets.fromLTRB(
                  10,
                  12,
                  10,
                  12,
                ),
                children: [
                  // =================================================
                  // SETTINGS
                  // =================================================

                  _buildMenuGroup(
                    context,
                    title: 'Settings',
                    icon: Icons.settings_outlined,
                    color: const Color(0xFF6366F1),
                    children: [
                      _buildChildMenuItem(
                        context,
                        icon: Icons.palette_outlined,
                        title: 'Theme & Appearance',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.themeSettings,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.fact_check_outlined,
                        title: 'Attendance Rules',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.attendanceSettings,
                          );
                        },
                      ),
                    ],
                  ),

                  // =================================================
                  // ORGANIZATION
                  // =================================================

                  _buildMenuGroup(
                    context,
                    title: 'Organization',
                    icon: Icons.business_center_outlined,
                    color: const Color(0xFF2196F3),
                    children: [
                      _buildChildMenuItem(
                        context,
                        icon: Icons.apartment_outlined,
                        title: 'Departments',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.departments,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.badge_outlined,
                        title: 'Designations',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.designations,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.schedule_outlined,
                        title: 'Shifts',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.shifts,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.admin_panel_settings_outlined,
                        title: 'Roles',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.roles,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.security_outlined,
                        title: 'Role Permissions',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.rolePermissions,
                          );
                        },
                      ),
                    ],
                  ),

                  // =================================================
                  // PEOPLE
                  // =================================================

                  _buildMenuGroup(
                    context,
                    title: 'People',
                    icon: Icons.people_alt_outlined,
                    color: const Color(0xFF10B981),
                    children: [
                      _buildChildMenuItem(
                        context,
                        icon: Icons.people_outline,
                        title: 'Employees',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.employees,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.manage_accounts_outlined,
                        title: 'Employee Accounts',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.employeesAccounts,
                          );
                        },
                      ),
                    ],
                  ),

                  // =================================================
                  // SUPERVISION
                  // =================================================

                  _buildMenuGroup(
                    context,
                    title: 'Supervision',
                    icon: Icons.supervisor_account_outlined,
                    color: const Color(0xFFF59E0B),
                    children: [
                      _buildChildMenuItem(
                        context,
                        icon: Icons.supervisor_account_outlined,
                        title: 'Supervisors',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.supervisors,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.assignment_ind_outlined,
                        title: 'Assign Departments',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.supervisorDepartmentAssignments,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.account_tree_outlined,
                        title: 'Manage Departments',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.supervisorDepartmentManage,
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.analytics_outlined,
                        title: 'Department Status',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.supervisorDepartmentStatus,
                          );
                        },
                      ),
                    ],
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

            _buildLogout(context),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // MENU GROUP
  // =============================================================

  Widget _buildMenuGroup(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required List<Widget> children,
      }) {
    // ===========================================================
    // IMPORTANT
    // ===========================================================
    //
    // এখানে Set ব্যবহার করা হয়নি।
    //
    // তাই একসাথে multiple parent open হতে পারবে না।
    //
    // ===========================================================

    final bool isExpanded = _expandedGroup == title;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: isExpanded
            ? color.withOpacity(.035)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded
              ? color.withOpacity(.18)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // =====================================================
          // PARENT HEADER
          // =====================================================

          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                _toggleGroup(title);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  11,
                  10,
                  11,
                ),
                child: Row(
                  children: [
                    // =================================================
                    // GROUP ICON
                    // =================================================

                    AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: color.withOpacity(
                          isExpanded ? .14 : .09,
                        ),
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 22,
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    // =================================================
                    // GROUP TITLE
                    // =================================================

                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: isExpanded
                              ? color
                              : Colors.grey.shade800,
                        ),
                      ),
                    ),

                    // =================================================
                    // ARROW
                    // =================================================

                    AnimatedRotation(
                      turns: isExpanded ? .5 : 0,
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isExpanded
                            ? color
                            : Colors.grey.shade500,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =====================================================
          // CHILDREN
          // =====================================================

          AnimatedCrossFade(
            duration: const Duration(
              milliseconds: 220,
            ),
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
            sizeCurve: Curves.easeInOut,
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                8,
                0,
                8,
                9,
              ),
              child: Column(
                children: [
                  // =================================================
                  // SEPARATOR
                  // =================================================

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Divider(
                      height: 1,
                      thickness: .8,
                      color: color.withOpacity(.12),
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  // =================================================
                  // CHILD ITEMS
                  // =================================================

                  ...children,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CHILD MENU ITEM
  // =============================================================

  Widget _buildChildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                // =================================================
                // CHILD ICON
                // =================================================

                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3)
                        .withOpacity(.07),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF2196F3),
                    size: 19,
                  ),
                ),

                const SizedBox(
                  width: 11,
                ),

                // =================================================
                // CHILD TITLE
                // =================================================

                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // =================================================
                // ARROW
                // =================================================

                Icon(
                  Icons.chevron_right_rounded,
                  size: 19,
                  color: Colors.grey.shade500,
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

  Widget _buildLogout(
      BuildContext context,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        10,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            Navigator.pop(context);

            await ref
                .read(authRepositoryProvider)
                .logout();

            ref
                .read(currentUserProvider.notifier)
                .logout();

            if (context.mounted) {
              context.go(
                RoutePaths.login,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(.035),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.red.withOpacity(.10),
              ),
            ),
            child: Row(
              children: [
                // =================================================
                // LOGOUT ICON
                // =================================================

                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.08),
                    borderRadius: BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 21,
                  ),
                ),

                const SizedBox(
                  width: 11,
                ),

                // =================================================
                // LOGOUT TEXT
                // =================================================

                const Expanded(
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // =================================================
                // ARROW
                // =================================================

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ],
            ),
          ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    displayName.isEmpty
                        ? '?'
                        : displayName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      user.loginUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.85),
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
          // LOGIN INFORMATION
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 11,
          ),

          _infoRow(
            icon: Icons.person_outline,
            label: 'Login Name',
            value: user.loginName,
          ),

          _infoRow(
            icon: Icons.account_circle_outlined,
            label: 'Login User',
            value: user.loginUser,
          ),

          _infoRow(
            icon: Icons.admin_panel_settings_outlined,
            label: 'Role',
            value: user.role.name,
          ),

          if (user.companyName != null &&
              user.companyName!.trim().isNotEmpty)
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
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(10),
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
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(.85),
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
                color: Colors.white.withOpacity(.72),
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
              value.trim().isEmpty ? '-' : value,
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
}