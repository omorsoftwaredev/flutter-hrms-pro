/// ===============================================================
/// Flutter HRMS Pro
/// Developer Dashboard
///
/// Version : 2.1.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/auth/permissions.dart';
import '../../../core/router/route_paths.dart';

import '../../dashboard/widgets/dashboard_app_bar.dart';
import '../widgets/developer_dashboard_sidebar.dart';

class DeveloperDashboardPage extends ConsumerWidget {
  const DeveloperDashboardPage({
    super.key,
  });

  // =============================================================
  // STAT CARD
  // =============================================================

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
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
      CurrentUser user,
      ) {
    final String displayName =
    user.fullName.trim().isNotEmpty
        ? user.fullName
        : user.loginName;

    final String initial =
    displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 24,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4F6AA5),
            Color(0xFF6078B5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
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
              CircleAvatar(
                radius: 31,
                backgroundColor:
                Colors.white.withOpacity(.90),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Color(0xFF435A93),
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Logged-in Account',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      displayName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Divider(
            color: Colors.white30,
            height: 1,
          ),

          const SizedBox(height: 16),

          // =====================================================
          // LOGIN NAME
          // =====================================================

          _infoRow(
            icon: Icons.person_outline,
            label: 'Login Name',
            value: user.loginName,
          ),

          const SizedBox(height: 10),

          // =====================================================
          // LOGIN USER
          // =====================================================

          _infoRow(
            icon:
            Icons.account_circle_outlined,
            label: 'Login User',
            value: user.loginUser,
          ),

          const SizedBox(height: 10),

          // =====================================================
          // ROLE
          // =====================================================

          _infoRow(
            icon:
            Icons.admin_panel_settings_outlined,
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

  static Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(.85),
          size: 17,
        ),

        const SizedBox(width: 8),

        SizedBox(
          width: 92,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ),

        const Text(
          ':',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // USER TYPE
  // =============================================================

  static String _userTypeTitle(
      String type,
      ) {
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
      CurrentUser user,
      ) {
    final permissions =
    user.permissions.toList();

    if (permissions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 24,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 22,
                color: Color(0xFF4F6AA5),
              ),

              SizedBox(width: 8),

              Text(
                'What you can do',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration:
                  BoxDecoration(
                    color:
                    const Color(0xFFF0F4FF),
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Text(
                    _permissionTitle(
                      permission,
                    ),
                    style:
                    const TextStyle(
                      color:
                      Color(0xFF435A93),
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w600,
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.black12,
        ),
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 5,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color:
            const Color(0xFF4F6AA5)
                .withOpacity(.08),
            borderRadius:
            BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 24,
            color:
            const Color(0xFF4F6AA5),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 17,
        ),
        onTap: onTap,
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

    // -----------------------------------------------------------
    // SESSION NOT LOADED
    // -----------------------------------------------------------

    if (user == null) {
      return const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      const Color(0xFFF8F9FC),

      // ---------------------------------------------------------
      // SIDEBAR
      // ---------------------------------------------------------

      drawer:
      const DeveloperDashboardSidebar(),

      // ---------------------------------------------------------
      // APP BAR
      // ---------------------------------------------------------

      appBar: const DashboardAppBar(
        title: 'Developer Dashboard',
      ),

      // ---------------------------------------------------------
      // BODY
      // ---------------------------------------------------------

      body: ListView(
        padding:
        const EdgeInsets.all(16),
        children: [

          // =====================================================
          // WELCOME
          // =====================================================

          Text(
            'Welcome, ${user.fullName.isNotEmpty ? user.fullName : user.loginName}',
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            '${_userTypeTitle(user.userType.name)} Dashboard',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // LOGIN INFORMATION
          // =====================================================

          _buildLoginInformation(
            user,
          ),

          // =====================================================
          // PERMISSIONS
          // =====================================================

          _buildPermissions(user),

          // =====================================================
          // SYSTEM SUMMARY
          // =====================================================

          const Text(
            'System Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildStatCard(
            icon:
            Icons.business_outlined,
            title: 'Total Companies',
            value: '0',
            color: Colors.blue,
          ),

          _buildStatCard(
            icon:
            Icons.manage_accounts_outlined,
            title: 'Company Accounts',
            value: '0',
            color: Colors.green,
          ),

          const SizedBox(height: 12),

          // =====================================================
          // DEVELOPER MENU
          // =====================================================

          const Text(
            'Developer Menu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildMenu(
            context,
            icon: Icons.add_business,
            title: 'Create Company',
            subtitle:
            'Create a new company',
            onTap: () {
              context.push(
                RoutePaths.companyCreate,
              );
            },
          ),

          _buildMenu(
            context,
            icon: Icons.business_outlined,
            title: 'Company List',
            subtitle:
            'View and manage companies',
            onTap: () {
              context.push(
                RoutePaths.companies,
              );
            },
          ),

          _buildMenu(
            context,
            icon:
            Icons.manage_accounts_outlined,
            title: 'Company Accounts',
            subtitle:
            'Manage company login accounts',
            onTap: () {
              context.push(
                RoutePaths.companyAccounts,
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}