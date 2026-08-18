/// ===============================================================
/// Flutter HRMS Pro
/// Developer Dashboard
///
/// Version : 2.2.0
///
/// Responsive + Theme Aware
/// Mobile / Tablet / Desktop
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/auth/permissions.dart';
import '../../../core/router/route_paths.dart';

import '../../../core/widgets/dashboard_appBar.dart';
import '../widgets/developer_dashboard_sidebar.dart';

class DeveloperDashboardPage extends ConsumerWidget {
  const DeveloperDashboardPage({
    super.key,
  });

  // =============================================================
  // RESPONSIVE HELPERS
  // =============================================================

  double _contentMaxWidth(double width) {
    if (width >= 1400) {
      return 1200;
    }

    if (width >= 1000) {
      return 1100;
    }

    return double.infinity;
  }

  double _pagePadding(double width) {
    if (width >= 1200) {
      return 32;
    }

    if (width >= 700) {
      return 24;
    }

    return 16;
  }

  // =============================================================
  // STAT CARD
  // =============================================================

  Widget _buildStatCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String value,
        required Color color,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant,
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
                color: color.withValues(alpha: 0.10),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
  // LOGIN INFORMATION
  // =============================================================

  Widget _buildLoginInformation(
      BuildContext context,
      CurrentUser user,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayName = user.fullName.trim().isNotEmpty
        ? user.fullName
        : user.loginName;

    final initial = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 31,
                backgroundColor:
                colorScheme.onPrimary.withValues(alpha: 0.95),
                child: Text(
                  initial,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                        colorScheme.onPrimary.withValues(alpha: 0.75),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
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
            color: colorScheme.onPrimary.withValues(alpha: 0.25),
            height: 1,
          ),

          const SizedBox(height: 16),

          _infoRow(
            context,
            icon: Icons.person_outline_rounded,
            label: 'Login Name',
            value: user.loginName,
          ),

          const SizedBox(height: 11),

          _infoRow(
            context,
            icon: Icons.account_circle_outlined,
            label: 'Login User',
            value: user.loginUser,
          ),

          const SizedBox(height: 11),

          _infoRow(
            context,
            icon: Icons.admin_panel_settings_outlined,
            label: 'Role',
            value: user.role.name,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: colorScheme.onPrimary.withValues(alpha: 0.85),
          size: 18,
        ),

        const SizedBox(width: 9),

        SizedBox(
          width: 95,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary.withValues(alpha: 0.70),
            ),
          ),
        ),

        Text(
          ':',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimary.withValues(alpha: 0.70),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // USER TYPE
  // =============================================================

  String _userTypeTitle(String type) {
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

  String _permissionTitle(
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
  // SECTION HEADER
  // =============================================================

  Widget _sectionHeader(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: colorScheme.onPrimaryContainer,
            size: 21,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================
  // PERMISSIONS
  // =============================================================

  Widget _buildPermissions(
      BuildContext context,
      CurrentUser user,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final permissions = user.permissions.toList();

    if (permissions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
              context,
              icon: Icons.verified_user_outlined,
              title: 'What you can do',
              subtitle:
              'Permissions available for your current account.',
            ),

            const SizedBox(height: 18),

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: permissions.map(
                    (permission) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Text(
                      _permissionTitle(permission),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // MENU ITEM
  // =============================================================

  Widget _buildMenu(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: colorScheme.outlineVariant,
        ),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  icon,
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final user = ref.watch(currentUserProvider);

    // ===========================================================
    // SESSION NOT LOADED
    // ===========================================================

    if (user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // SIDEBAR
      // =========================================================

      drawer: const DeveloperDashboardSidebar(),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: const DashboardAppBar(
        title: 'Developer Dashboard',
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: LayoutBuilder(
        builder: (
            BuildContext context,
            BoxConstraints constraints,
            ) {
          final width = constraints.maxWidth;

          final horizontalPadding = _pagePadding(width);
          final maxWidth = _contentMaxWidth(width);

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),

              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  32,
                ),

                children: [

                  // =================================================
                  // WELCOME HEADER
                  // =================================================

                  Text(
                    'Welcome, ${user.fullName.isNotEmpty ? user.fullName : user.loginName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${_userTypeTitle(user.userType.name)} Dashboard',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // =================================================
                  // LOGIN INFORMATION
                  // =================================================

                  _buildLoginInformation(
                    context,
                    user,
                  ),

                  const SizedBox(height: 22),

                  // =================================================
                  // PERMISSIONS
                  // =================================================

                  _buildPermissions(
                    context,
                    user,
                  ),

                  if (user.permissions.isNotEmpty)
                    const SizedBox(height: 24),

                  // =================================================
                  // SYSTEM SUMMARY
                  // =================================================

                  _sectionHeader(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'System Summary',
                    subtitle:
                    'Quick overview of your HRMS system.',
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // RESPONSIVE STAT GRID
                  // =================================================

                  LayoutBuilder(
                    builder: (
                        context,
                        constraints,
                        ) {
                      final availableWidth =
                          constraints.maxWidth;

                      final isWide =
                          availableWidth >= 650;

                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon:
                                Icons.business_outlined,
                                title:
                                'Total Companies',
                                value: '0',
                                color:
                                colorScheme.primary,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: _buildStatCard(
                                context,
                                icon:
                                Icons.manage_accounts_outlined,
                                title:
                                'Company Accounts',
                                value: '0',
                                color:
                                colorScheme.tertiary,
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          _buildStatCard(
                            context,
                            icon:
                            Icons.business_outlined,
                            title:
                            'Total Companies',
                            value: '0',
                            color:
                            colorScheme.primary,
                          ),

                          const SizedBox(height: 14),

                          _buildStatCard(
                            context,
                            icon:
                            Icons.manage_accounts_outlined,
                            title:
                            'Company Accounts',
                            value: '0',
                            color:
                            colorScheme.tertiary,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // =================================================
                  // DEVELOPER MENU
                  // =================================================

                  _sectionHeader(
                    context,
                    icon: Icons.apps_outlined,
                    title: 'Developer Menu',
                    subtitle:
                    'Manage companies and system accounts.',
                  ),

                  const SizedBox(height: 14),

                  // =================================================
                  // MENU GRID
                  // =================================================

                  LayoutBuilder(
                    builder: (
                        context,
                        constraints,
                        ) {
                      final availableWidth =
                          constraints.maxWidth;

                      final isDesktop =
                          availableWidth >= 850;

                      // =================================================
                      // DESKTOP
                      // =================================================

                      if (isDesktop) {
                        return GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          shrinkWrap: true,

                          physics:
                          const NeverScrollableScrollPhysics(),

                          childAspectRatio: 3.4,

                          children: [

                            // -------------------------------------------------
                            // CREATE COMPANY
                            // -------------------------------------------------

                            _buildMenu(
                              context,
                              icon:
                              Icons.add_business_outlined,
                              title:
                              'Create Company',
                              subtitle:
                              'Create a new company',
                              onTap: () {
                                context.push(
                                  RoutePaths.companyCreate,
                                );
                              },
                            ),

                            // -------------------------------------------------
                            // COMPANY LIST
                            // -------------------------------------------------

                            _buildMenu(
                              context,
                              icon:
                              Icons.business_outlined,
                              title:
                              'Company List',
                              subtitle:
                              'View and manage companies',
                              onTap: () {
                                context.push(
                                  RoutePaths.companies,
                                );
                              },
                            ),

                            // -------------------------------------------------
                            // COMPANY ACCOUNTS
                            // -------------------------------------------------

                            _buildMenu(
                              context,
                              icon:
                              Icons.manage_accounts_outlined,
                              title:
                              'Company Accounts',
                              subtitle:
                              'Manage company login accounts',
                              onTap: () {
                                context.push(
                                  RoutePaths.companyAccounts,
                                );
                              },
                            ),

                            // -------------------------------------------------
                            // THEME & APPEARANCE
                            // -------------------------------------------------

                            _buildMenu(
                              context,
                              icon:
                              Icons.palette_outlined,
                              title:
                              'Theme & Appearance',
                              subtitle:
                              'Customize app theme and appearance',
                              onTap: () {
                                context.push(
                                  RoutePaths.themeSettings,
                                );
                              },
                            ),
                          ],
                        );
                      }

                      // =================================================
                      // MOBILE / TABLET
                      // =================================================

                      return Column(
                        children: [

                          // -------------------------------------------------
                          // CREATE COMPANY
                          // -------------------------------------------------

                          _buildMenu(
                            context,
                            icon:
                            Icons.add_business_outlined,
                            title:
                            'Create Company',
                            subtitle:
                            'Create a new company',
                            onTap: () {
                              context.push(
                                RoutePaths.companyCreate,
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // -------------------------------------------------
                          // COMPANY LIST
                          // -------------------------------------------------

                          _buildMenu(
                            context,
                            icon:
                            Icons.business_outlined,
                            title:
                            'Company List',
                            subtitle:
                            'View and manage companies',
                            onTap: () {
                              context.push(
                                RoutePaths.companies,
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // -------------------------------------------------
                          // COMPANY ACCOUNTS
                          // -------------------------------------------------

                          _buildMenu(
                            context,
                            icon:
                            Icons.manage_accounts_outlined,
                            title:
                            'Company Accounts',
                            subtitle:
                            'Manage company login accounts',
                            onTap: () {
                              context.push(
                                RoutePaths.companyAccounts,
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // -------------------------------------------------
                          // THEME & APPEARANCE
                          // -------------------------------------------------

                          _buildMenu(
                            context,
                            icon:
                            Icons.palette_outlined,
                            title:
                            'Theme & Appearance',
                            subtitle:
                            'Customize app theme and appearance',
                            onTap: () {
                              context.push(
                                RoutePaths.themeSettings,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}