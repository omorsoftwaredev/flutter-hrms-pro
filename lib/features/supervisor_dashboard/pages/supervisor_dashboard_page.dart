// ===============================================================
// Flutter HRMS Pro
// Company Dashboard
//
// Version : 2.3.0
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/route_paths.dart';

import '../../../core/widgets/dashboard_appBar.dart';
import '../widgets/supervisor_dashboard_sidebar.dart';

class SupervisorDashboardPage extends ConsumerWidget {
  const SupervisorDashboardPage({
    super.key,
  });

  // =============================================================
  // SUMMARY CARD
  // =============================================================

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 29,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
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
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),

        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3)
                .withOpacity(.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2196F3),
            size: 22,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
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
          size: 21,
        ),

        onTap: onTap,
      ),
    );
  }

  // =============================================================
  // LOGIN INFORMATION
  // =============================================================

  Widget _buildLoginInformation(
      CurrentUser user,
      ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // ===================================================
            // TITLE
            // ===================================================

            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3)
                        .withOpacity(.10),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF2196F3),
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login Information',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Current account information',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ===================================================
            // LOGIN NAME
            // ===================================================

            _infoRow(
              icon: Icons.person_outline,
              label: 'Login Name',
              value: user.loginName,
            ),

            // ===================================================
            // LOGIN USER
            // ===================================================

            _infoRow(
              icon: Icons.account_circle_outlined,
              label: 'Login User',
              value: user.loginUser,
            ),

            // ===================================================
            // ROLE
            // ===================================================

            _infoRow(
              icon:
              Icons.admin_panel_settings_outlined,
              label: 'Role',
              value: user.role.name,
            ),

            // ===================================================
            // COMPANY
            // ===================================================

            if (user.companyName != null &&
                user.companyName!
                    .trim()
                    .isNotEmpty)
              _infoRow(
                icon: Icons.business_outlined,
                label: 'Company',
                value: user.companyName!,
              ),

            const SizedBox(height: 8),

            // ===================================================
            // PERMISSIONS
            // ===================================================

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.07),
                borderRadius:
                BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green
                      .withOpacity(.15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.security_outlined,
                    color: Colors.green,
                    size: 19,
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Text(
                      '${user.permissions.length} permissions available',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 18,
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
  // INFO ROW
  // =============================================================

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 9,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey.shade600,
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const Text(
            ':',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              value.trim().isEmpty
                  ? '-'
                  : value,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
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
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final CurrentUser? user =
    ref.watch(currentUserProvider);

    // ===========================================================
    // USER LOADING
    // ===========================================================

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      drawer:
      const SupervisorDashboardSidebar(),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: const DashboardAppBar(
        title: 'Supervisor',
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // =====================================================
          // WELCOME
          // =====================================================

          Text(
            'Welcome ${user.displayName}',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'HRMS Pro Supervisor Management Panel',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          // =====================================================
          // LOGIN INFORMATION
          // =====================================================

          _buildLoginInformation(user),

          // =====================================================
          // SUMMARY
          // =====================================================

          const Text(
            'Company Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          _buildCard(
            icon: Icons.apartment_outlined,
            title: 'Departments',
            value: '0',
            color: Colors.blue,
          ),

          _buildCard(
            icon: Icons.badge_outlined,
            title: 'Designations',
            value: '0',
            color: Colors.orange,
          ),

          _buildCard(
            icon: Icons.people_outline,
            title: 'Employees',
            value: '0',
            color: Colors.green,
          ),

          _buildCard(
            icon: Icons.manage_accounts_outlined,
            title: 'Employee Accounts',
            value: '0',
            color: Colors.purple,
          ),

          const SizedBox(height: 14),

          // =====================================================
          // COMPANY MENU
          // =====================================================

          const Text(
            'Company Management',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // =====================================================
          // DEPARTMENTS
          // =====================================================

          _buildMenu(
            context,
            icon: Icons.apartment_outlined,
            title: 'Attendance',
            subtitle:
            'Attendance Report',
            onTap: () {
              context.push(
                RoutePaths.departments,
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}