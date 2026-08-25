// ===============================================================
// Flutter HRMS Pro
// Company Dashboard Sidebar
//
// Version : 2.8.1
//
// Theme Aware:
// - Light / Dark Theme Support
// - Material 3
// - Uses Theme.of(context).colorScheme
// - No hard-coded background colors
// - No hard-coded text colors
// - No hard-coded primary colors
// - Accordion style parent menu
// - Only one parent group opens at a time
// - Previous parent automatically closes
// - Cleaner child menu separation
// - Meaningful single-line menu labels
// - Existing routes preserved
// - Attendance Mobile Report added under Reports
// - Dynamic companyId navigation
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
  const CompanyDashboardSidebar({super.key});

  @override
  ConsumerState<CompanyDashboardSidebar> createState() =>
      _CompanyDashboardSidebarState();
}

class _CompanyDashboardSidebarState
    extends ConsumerState<CompanyDashboardSidebar> {
  // =============================================================
  // CURRENTLY OPEN GROUP
  // =============================================================

  String? _expandedGroup = 'Organization';

  // =============================================================
  // TOGGLE GROUP
  // =============================================================

  void _toggleGroup(String group) {
    setState(() {
      if (_expandedGroup == group) {
        _expandedGroup = null;
      } else {
        _expandedGroup = group;
      }
    });
  }

  // =============================================================
  // CLOSE DRAWER + NAVIGATE
  // =============================================================

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.push(route);
  }

  // =============================================================
  // NAVIGATE TO ATTENDANCE MOBILE REPORT
  //
  // Attendance Mobile Report page requires:
  // companyId
  //
  // companyId is taken dynamically from CurrentUser.
  // =============================================================

  void _openAttendanceMobileTodayReport(
    BuildContext context,
    CurrentUser user,
  ) {
    final companyId = user.companyId.trim();

    // ===========================================================
    // COMPANY ID VALIDATION
    // ===========================================================

    if (companyId.isEmpty) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Company ID is not available.'),
            behavior: SnackBarBehavior.floating,
          ),
        );

      return;
    }

    // ===========================================================
    // CLOSE DRAWER
    // ===========================================================

    Navigator.pop(context);

    // ===========================================================
    // BUILD REPORT ROUTE
    // ===========================================================

    final route =
        '${RoutePaths.CompanyTodayAttendanceReport}'
        '?companyId=${Uri.encodeComponent(companyId)}';

    // ===========================================================
    // NAVIGATE
    // ===========================================================

    context.push(route);
  }

  void _openAttendanceMobileDateWiseReport(
      BuildContext context,
      CurrentUser user,
      ) {
    final companyId = user.companyId.trim();

    // ===========================================================
    // COMPANY ID VALIDATION
    // ===========================================================

    if (companyId.isEmpty) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Company ID is not available.'),
            behavior: SnackBarBehavior.floating,
          ),
        );

      return;
    }

    // ===========================================================
    // CLOSE DRAWER
    // ===========================================================

    Navigator.pop(context);

    // ===========================================================
    // BUILD REPORT ROUTE
    // ===========================================================

    final route =
        '${RoutePaths.CompanyDatewiseAttendanceReport}'
        '?companyId=${Uri.encodeComponent(companyId)}';

    // ===========================================================
    // NAVIGATE
    // ===========================================================

    context.push(route);
  }
  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final CurrentUser? user = ref.watch(currentUserProvider);

    // ===========================================================
    // USER NOT AVAILABLE
    // ===========================================================

    if (user == null) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }

    // ===========================================================
    // DRAWER
    // ===========================================================

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // ===================================================
            // USER HEADER
            // ===================================================
            _buildUserHeader(context, user),

            // ===================================================
            // MENU
            // ===================================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                children: [
                  // =================================================
                  // SETTINGS
                  // =================================================
                  _buildMenuGroup(
                    context,
                    title: 'Settings',
                    icon: Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    children: [
                      // ===========================================
                      // THEME & APPEARANCE
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.palette_outlined,
                        title: 'Theme & Appearance',
                        onTap: () {
                          _navigate(context, RoutePaths.themeSettings);
                        },
                      ),

                      // ===========================================
                      // WORKDAYS SETTINGS
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.fact_check_outlined,
                        title: 'Workdays Settings',
                        onTap: () {
                          _navigate(context, RoutePaths.workingDaysSettings);
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
                    color: Theme.of(context).colorScheme.primary,
                    children: [
                      // ===========================================
                      // DEPARTMENTS
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.apartment_outlined,
                        title: 'Departments',
                        onTap: () {
                          _navigate(context, RoutePaths.departments);
                        },
                      ),

                      // ===========================================
                      // DESIGNATIONS
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.badge_outlined,
                        title: 'Designations',
                        onTap: () {
                          _navigate(context, RoutePaths.designations);
                        },
                      ),

                      // ===========================================
                      // SHIFTS
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.schedule_outlined,
                        title: 'Shifts',
                        onTap: () {
                          _navigate(context, RoutePaths.shifts);
                        },
                      ),

                      // ===========================================
                      // ROLES
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.admin_panel_settings_outlined,
                        title: 'Roles',
                        onTap: () {
                          _navigate(context, RoutePaths.roles);
                        },
                      ),

                      // ===========================================
                      // ROLE PERMISSIONS
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.security_outlined,
                        title: 'Role Permissions',
                        onTap: () {
                          _navigate(context, RoutePaths.rolePermissions);
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
                    color: Theme.of(context).colorScheme.secondary,
                    children: [
                      // ===========================================
                      // EMPLOYEES
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.people_outline,
                        title: 'Employees',
                        onTap: () {
                          _navigate(context, RoutePaths.employees);
                        },
                      ),

                      // ===========================================
                      // EMPLOYEE ACCOUNTS
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.manage_accounts_outlined,
                        title: 'Employee Accounts',
                        onTap: () {
                          _navigate(context, RoutePaths.employeesAccounts);
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
                    color: Theme.of(context).colorScheme.tertiary,
                    children: [
                      // ===========================================
                      // SUPERVISORS
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.supervisor_account_outlined,
                        title: 'Supervisors',
                        onTap: () {
                          _navigate(context, RoutePaths.supervisors);
                        },
                      ),

                      // ===========================================
                      // ASSIGN DEPARTMENTS
                      // ===========================================
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

                      // ===========================================
                      // MANAGE DEPARTMENTS
                      // ===========================================
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

                      // ===========================================
                      // DEPARTMENT STATUS
                      // ===========================================
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

                  // =================================================
                  // REPORTS
                  // =================================================
                  _buildMenuGroup(
                    context,
                    title: 'Reports',
                    icon: Icons.assessment_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    children: [
                      // ===========================================
                      // ATTENDANCE MOBILE REPORT
                      // ===========================================
                      _buildChildMenuItem(
                        context,
                        icon: Icons.fact_check_outlined,
                        title: 'Supervisor Wise Attendance Report',
                        onTap: () {
                          _openAttendanceMobileTodayReport(context, user);
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.fact_check_outlined,
                        title: 'Dept Wise Attendance Report',
                        onTap: () {
                          _openAttendanceMobileTodayReport(context, user);
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
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
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
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final bool isExpanded = _expandedGroup == title;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isExpanded
            ? color.withValues(alpha: 0.055)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isExpanded
              ? color.withValues(alpha: 0.20)
              : colorScheme.outlineVariant,
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
              borderRadius: BorderRadius.circular(17),
              onTap: () {
                _toggleGroup(title);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 11, 10, 11),
                child: Row(
                  children: [
                    // =========================================
                    // GROUP ICON
                    // =========================================
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(
                          alpha: isExpanded ? 0.15 : 0.09,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),

                    const SizedBox(width: 12),

                    // =========================================
                    // TITLE
                    // =========================================
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isExpanded ? color : colorScheme.onSurface,
                        ),
                      ),
                    ),

                    // =========================================
                    // ARROW
                    // =========================================
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 25,
                        color: isExpanded
                            ? color
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =====================================================
          // SUB MENU
          // =====================================================
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 9),
                    child: Column(
                      children: [
                        // =========================================
                        // DIVIDER
                        // =========================================
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Divider(
                            height: 1,
                            thickness: 0.8,
                            color: color.withValues(alpha: 0.14),
                          ),
                        ),

                        const SizedBox(height: 7),

                        // =========================================
                        // CHILDREN
                        // =========================================
                        ...children,
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
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
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                // ===============================================
                // ICON
                // ===============================================
                Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.onPrimaryContainer,
                    size: 19,
                  ),
                ),

                const SizedBox(width: 11),

                // ===============================================
                // TITLE
                // ===============================================
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                // ===============================================
                // ARROW
                // ===============================================
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
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

  Widget _buildLogout(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final Color errorColor = colorScheme.error;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            // =================================================
            // CLOSE DRAWER
            // =================================================

            Navigator.pop(context);

            // =================================================
            // LOGOUT AUTH
            // =================================================

            await ref.read(authRepositoryProvider).logout();

            // =================================================
            // CLEAR CURRENT USER
            // =================================================

            ref.read(currentUserProvider.notifier).logout();

            // =================================================
            // NAVIGATE LOGIN
            // =================================================

            if (context.mounted) {
              context.go(RoutePaths.login);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: errorColor.withValues(alpha: .07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: errorColor.withValues(alpha: .18)),
            ),
            child: Row(
              children: [
                // ===============================================
                // LOGOUT ICON
                // ===============================================
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: errorColor.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: errorColor,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 11),

                // ===============================================
                // LOGOUT TEXT
                // ===============================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logout',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: errorColor,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Sign out from your account',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ===============================================
                // ARROW
                // ===============================================
                Icon(Icons.chevron_right_rounded, size: 20, color: errorColor),
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

  Widget _buildUserHeader(BuildContext context, CurrentUser user) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final String displayName = user.displayName.trim().isNotEmpty
        ? user.displayName
        : user.loginName;

    final Color headerColor = colorScheme.primary;

    final Color headerOnColor = colorScheme.onPrimary;

    final Color headerMutedColor = colorScheme.onPrimary.withValues(alpha: .78);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 20, 17, 17),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: const BorderRadius.only(
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
              // =================================================
              // PROFILE AVATAR
              // =================================================
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: headerOnColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    displayName.isEmpty ? '?' : displayName[0].toUpperCase(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: headerColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // =================================================
              // USER DETAILS
              // =================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: headerOnColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      user.loginUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: headerMutedColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =====================================================
          // LOGIN INFORMATION
          // =====================================================
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: headerOnColor,
                size: 17,
              ),

              const SizedBox(width: 7),

              Text(
                'Login Information',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: headerOnColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          // =====================================================
          // LOGIN NAME
          // =====================================================
          _infoRow(
            context,
            icon: Icons.person_outline,
            label: 'Login Name',
            value: user.loginName,
          ),

          // =====================================================
          // LOGIN USER
          // =====================================================
          _infoRow(
            context,
            icon: Icons.account_circle_outlined,
            label: 'Login User',
            value: user.loginUser,
          ),

          // =====================================================
          // ROLE
          // =====================================================
          _infoRow(
            context,
            icon: Icons.admin_panel_settings_outlined,
            label: 'Role',
            value: user.role.name,
          ),

          // =====================================================
          // COMPANY
          // =====================================================
          if (user.companyName != null && user.companyName!.trim().isNotEmpty)
            _infoRow(
              context,
              icon: Icons.business_outlined,
              label: 'Company',
              value: user.companyName!,
            ),

          const SizedBox(height: 9),

          // =====================================================
          // PERMISSIONS
          // =====================================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: headerOnColor.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.security_outlined, color: headerOnColor, size: 16),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    '${user.permissions.length} permissions available',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: headerOnColor,
                      fontSize: 11,
                    ),
                  ),
                ),

                Icon(
                  Icons.check_circle_outline,
                  color: headerOnColor,
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

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final Color onHeader = colorScheme.onPrimary;

    final Color muted = colorScheme.onPrimary.withValues(alpha: .72);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // ICON
          // =====================================================
          Icon(icon, color: onHeader.withValues(alpha: .85), size: 15),

          const SizedBox(width: 7),

          // =====================================================
          // LABEL
          // =====================================================
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: muted, fontSize: 10.5),
            ),
          ),

          // =====================================================
          // COLON
          // =====================================================
          Text(
            ':',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: onHeader.withValues(alpha: .70),
              fontSize: 11,
            ),
          ),

          const SizedBox(width: 5),

          // =====================================================
          // VALUE
          // =====================================================
          Expanded(
            child: Text(
              value.trim().isEmpty ? '-' : value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: onHeader,
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
