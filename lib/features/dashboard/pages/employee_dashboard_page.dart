/// ===============================================================
/// Flutter HRMS Pro
/// Employee Dashboard
///
/// Version : 2.1.0
///
/// Design update:
/// - Theme aware (Light / Dark)
/// - Responsive (Mobile / Tablet / Desktop)
/// - Existing functionality preserved
/// - Existing routes preserved
/// - Existing sidebar preserved
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/auth/permissions.dart';
import '../../../core/router/route_paths.dart';

import '../../../core/widgets/dashboard_appBar.dart';
import '../widgets/employee_dashboard_sidebar.dart';

class EmployeeDashboardPage extends ConsumerWidget {
  const EmployeeDashboardPage({
    super.key,
  });

  // =============================================================
  // RESPONSIVE HELPERS
  // =============================================================

  double _horizontalPadding(double width) {
    if (width >= 1400) return 40;
    if (width >= 1000) return 32;
    if (width >= 600) return 24;
    return 16;
  }

  double _contentMaxWidth(double width) {
    if (width >= 1400) return 1250;
    if (width >= 1000) return 1150;
    return double.infinity;
  }

  // =============================================================
  // STAT CARD
  // =============================================================

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: theme.brightness == Brightness.dark ? 0 : 1,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: scheme.outline.withOpacity(.10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // LOGIN INFORMATION CARD
  // =============================================================

  Widget _buildLoginInformation(
      BuildContext context,
      CurrentUser user,
      ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final String employeeName =
    user.employeeName != null &&
        user.employeeName!.trim().isNotEmpty
        ? user.employeeName!
        : user.fullName;

    final String companyName =
    user.companyName != null &&
        user.companyName!.trim().isNotEmpty
        ? user.companyName!
        : '-';

    final String departmentName =
    user.departmentName != null &&
        user.departmentName!.trim().isNotEmpty
        ? user.departmentName!
        : '-';

    final String designationName =
    user.designationName != null &&
        user.designationName!.trim().isNotEmpty
        ? user.designationName!
        : '-';

    final String initial =
    employeeName.isNotEmpty
        ? employeeName[0].toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.alphaBlend(
              scheme.primary.withOpacity(.72),
              scheme.surface,
            ),
          ],
        ),
        boxShadow: theme.brightness == Brightness.light
            ? [
          BoxShadow(
            color: scheme.primary.withOpacity(.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================================================
          // PROFILE HEADER
          // =====================================================

          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: scheme.onPrimary.withOpacity(.95),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: scheme.primary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Logged-in Account',
                      style: TextStyle(
                        color: scheme.onPrimary.withOpacity(.72),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(
            color: scheme.onPrimary.withOpacity(.20),
            height: 1,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // LOGIN NAME
          // =====================================================

          _infoRow(
            context: context,
            icon: Icons.person_outline,
            label: 'Login Name',
            value: user.loginName,
          ),

          const SizedBox(height: 10),

          // =====================================================
          // LOGIN USER
          // =====================================================

          _infoRow(
            context: context,
            icon: Icons.account_circle_outlined,
            label: 'Login User',
            value: user.loginUser,
          ),

          const SizedBox(height: 10),

          // =====================================================
          // ROLE
          // =====================================================

          _infoRow(
            context: context,
            icon: Icons.admin_panel_settings_outlined,
            label: 'Role',
            value: user.role.name,
          ),

          const SizedBox(height: 10),

          // =====================================================
          // EMPLOYEE
          // =====================================================

          _infoRow(
            context: context,
            icon: Icons.badge_outlined,
            label: 'Employee',
            value: employeeName,
          ),

          // =====================================================
          // COMPANY
          // =====================================================

          if (companyName != '-') ...[
            const SizedBox(height: 10),
            _infoRow(
              context: context,
              icon: Icons.business_outlined,
              label: 'Company',
              value: companyName,
            ),
          ],

          // =====================================================
          // DEPARTMENT
          // =====================================================

          if (departmentName != '-') ...[
            const SizedBox(height: 10),
            _infoRow(
              context: context,
              icon: Icons.account_tree_outlined,
              label: 'Department',
              value: departmentName,
            ),
          ],

          // =====================================================
          // DESIGNATION
          // =====================================================

          if (designationName != '-') ...[
            const SizedBox(height: 10),
            _infoRow(
              context: context,
              icon: Icons.work_outline,
              label: 'Designation',
              value: designationName,
            ),
          ],
        ],
      ),
    );
  }

  // =============================================================
  // INFO ROW
  // =============================================================

  static Widget _infoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: scheme.onPrimary.withOpacity(.82),
          size: 17,
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 92,
          child: Text(
            label,
            style: TextStyle(
              color: scheme.onPrimary.withOpacity(.68),
              fontSize: 12,
            ),
          ),
        ),

        Text(
          ':',
          style: TextStyle(
            color: scheme.onPrimary.withOpacity(.68),
            fontSize: 12,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // USER TYPE TITLE
  // =============================================================

  static String _userTypeTitle(String type) {
    switch (type.toLowerCase()) {
      case 'developer':
        return 'Developer';

      case 'company':
        return 'Company Owner';

      case 'hr':
        return 'HR';

      case 'supervisor':
        return 'Supervisor';

      case 'employee':
        return 'Employee';

      default:
        return type;
    }
  }

  // =============================================================
  // PERMISSION TITLE
  // =============================================================

  static String _permissionTitle(
      Permission permission,
      ) {
    switch (permission) {
      case Permission.viewDashboard:
        return 'Dashboard';

      case Permission.attendanceView:
        return 'View Attendance';

      case Permission.attendanceCreate:
        return 'Create Attendance';

      case Permission.attendanceUpdate:
        return 'Update Attendance';

      case Permission.attendanceDelete:
        return 'Delete Attendance';

      case Permission.attendanceCheckIn:
        return 'Check In';

      case Permission.attendanceCheckOut:
        return 'Check Out';

      case Permission.leaveView:
        return 'View Leave';

      case Permission.leaveCreate:
        return 'Apply Leave';

      case Permission.leaveApprove:
        return 'Approve Leave';

      case Permission.reportsView:
        return 'View Reports';

      case Permission.employeeView:
        return 'View Employees';

      case Permission.employeeCreate:
        return 'Create Employee';

      case Permission.employeeUpdate:
        return 'Update Employee';

      case Permission.employeeDelete:
        return 'Delete Employee';

      case Permission.companyView:
        return 'View Company';

      case Permission.companyCreate:
        return 'Create Company';

      case Permission.companyUpdate:
        return 'Update Company';

      case Permission.companyDelete:
        return 'Delete Company';

      case Permission.departmentView:
        return 'View Department';

      case Permission.departmentCreate:
        return 'Create Department';

      case Permission.departmentUpdate:
        return 'Update Department';

      case Permission.departmentDelete:
        return 'Delete Department';

      case Permission.designationView:
        return 'View Designation';

      case Permission.designationCreate:
        return 'Create Designation';

      case Permission.designationUpdate:
        return 'Update Designation';

      case Permission.designationDelete:
        return 'Delete Designation';

      case Permission.shiftView:
        return 'View Shift';

      case Permission.shiftCreate:
        return 'Create Shift';

      case Permission.shiftUpdate:
        return 'Update Shift';

      case Permission.shiftDelete:
        return 'Delete Shift';

      case Permission.settingsView:
        return 'Settings';
    }
  }

  // =============================================================
  // PERMISSIONS
  // =============================================================

  Widget _buildPermissions(
      BuildContext context,
      CurrentUser user,
      ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final permissions = user.permissions.toList();

    if (permissions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outline.withOpacity(.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 22,
                color: scheme.primary,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  'What you can do',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: permissions.map(
                  (permission) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(.09),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: scheme.primary.withOpacity(.10),
                    ),
                  ),
                  child: Text(
                    _permissionTitle(permission),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // MENU
  // =============================================================

  Widget _buildMenu(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      elevation: theme.brightness == Brightness.dark ? 0 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: scheme.outline.withOpacity(.10),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),

        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(.09),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 24,
            color: scheme.primary,
          ),
        ),

        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: scheme.onSurfaceVariant,
        ),

        onTap: onTap,
      ),
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _buildSectionTitle(
      BuildContext context,
      String title,
      ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -.2,
        ),
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final CurrentUser? user =
    ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final horizontalPadding =
        _horizontalPadding(width);

        final maxWidth =
        _contentMaxWidth(width);

        return Scaffold(
          backgroundColor:
          Theme.of(context).colorScheme.surfaceContainerLowest,

          // =======================================================
          // EXISTING SIDEBAR — UNCHANGED
          // =======================================================

          drawer:
          const EmployeeDashboardSidebar(),

          // =======================================================
          // EXISTING APP BAR — UNCHANGED
          // =======================================================

          appBar: const DashboardAppBar(
            title: 'Dashboard',
          ),

          // =======================================================
          // BODY
          // =======================================================

          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  width >= 600 ? 24 : 16,
                  horizontalPadding,
                  28,
                ),
                children: [
                  // =================================================
                  // WELCOME
                  // =================================================

                  Text(
                    'Welcome, ${user.displayEmployeeName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.4,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${_userTypeTitle(user.userType.name)} Dashboard',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =================================================
                  // LOGIN INFORMATION
                  // =================================================

                  _buildLoginInformation(
                    context,
                    user,
                  ),

                  // =================================================
                  // PERMISSIONS
                  // =================================================

                  _buildPermissions(
                    context,
                    user,
                  ),

                  // =================================================
                  // ATTENDANCE SUMMARY
                  // =================================================

                  _buildSectionTitle(
                    context,
                    'Attendance Summary',
                  ),

                  // Desktop/tablet grid.
                  // Mobile remains one column.
                  if (width >= 800)
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context: context,
                            icon:
                            Icons.calendar_month_outlined,
                            title:
                            'Total Attendance',
                            value: '0',
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildStatCard(
                            context: context,
                            icon:
                            Icons.access_time_outlined,
                            title:
                            'Late Attendance',
                            value: '0',
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildStatCard(
                            context: context,
                            icon:
                            Icons.event_available_outlined,
                            title:
                            'Approved Leave',
                            value: '0',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _buildStatCard(
                      context: context,
                      icon:
                      Icons.calendar_month_outlined,
                      title: 'Total Attendance',
                      value: '0',
                      color: Colors.blue,
                    ),

                    _buildStatCard(
                      context: context,
                      icon:
                      Icons.access_time_outlined,
                      title: 'Late Attendance',
                      value: '0',
                      color: Colors.orange,
                    ),

                    _buildStatCard(
                      context: context,
                      icon:
                      Icons.event_available_outlined,
                      title: 'Approved Leave',
                      value: '0',
                      color: Colors.green,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // =================================================
                  // EMPLOYEE MENU
                  // =================================================

                  _buildSectionTitle(
                    context,
                    'Employee Menu',
                  ),


                  _buildMenu(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Theme & Appearance',
                    subtitle: 'Customize app theme and appearance',
                    onTap: () {
                      context.push(
                        RoutePaths.themeSettings,
                      );
                    },
                  ),

                  _buildMenu(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    subtitle: 'Employee Dashboard',
                    onTap: () {},
                  ),

                  _buildMenu(
                    context,
                    icon: Icons.badge_outlined,
                    title: 'Mobile Attendance',
                    subtitle: 'Check In / Check Out',
                    onTap: () {
                      context.push(
                        RoutePaths.mobileAttendance,
                      );
                    },
                  ),

                  _buildMenu(
                    context,
                    icon: Icons.bar_chart_outlined,
                    title: 'Attendance Report',
                    subtitle:
                    'View your attendance report',
                    onTap: () {
                      context.push(
                        RoutePaths.attendanceReport,
                      );
                    },
                  ),

                  _buildMenu(
                    context,
                    icon: Icons.lock_reset_outlined,
                    title: 'Change Password',
                    subtitle:
                    'Keep your account secure',
                    onTap: () {
                      context.push(
                        RoutePaths.changePassword,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}