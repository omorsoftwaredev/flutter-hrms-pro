/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Dashboard
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../dashboard/widgets/dashboard_app_bar.dart';
import '../widgets/supervisor_dashboard_sidebar.dart';

class SupervisorDashboardPage
    extends ConsumerWidget {
  const SupervisorDashboardPage({
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

      drawer:
      const SupervisorDashboardSidebar(),

      appBar: const DashboardAppBar(
        title: 'Supervisor Dashboard',
      ),

      body: ListView(
        padding:
        const EdgeInsets.all(16),
        children: [
          // =====================================================
          // WELCOME
          // =====================================================

          Text(
            'Welcome, ${user.displayName}',
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 25,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          const Text(
            'Supervisor Control Panel',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(
            height: 22,
          ),

          // =====================================================
          // SUPERVISOR INFORMATION
          // =====================================================

          Card(
            elevation: 0,
            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(
                20,
              ),
              side:
              const BorderSide(
                color: Colors.black12,
              ),
            ),
            child: Padding(
              padding:
              const EdgeInsets.all(
                20,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: Icon(
                          Icons
                              .supervisor_account_outlined,
                        ),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Text(
                        'Supervisor Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  _infoRow(
                    'Name',
                    user.displayName,
                  ),

                  _infoRow(
                    'Login',
                    user.loginName,
                  ),

                  _infoRow(
                    'Role',
                    user.role.name,
                  ),

                  _infoRow(
                    'Company',
                    user.displayCompanyName,
                  ),

                  _infoRow(
                    'Department',
                    user.displayDepartmentName,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // =====================================================
          // STAT CARDS
          // =====================================================

          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.people_outline,
                  title:
                  'My Employees',
                  value: '0',
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: _statCard(
                  icon:
                  Icons.pending_actions_outlined,
                  title:
                  'Pending Requests',
                  value: '0',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          // =====================================================
          // NOTE
          // =====================================================

          Card(
            elevation: 0,
            child: Padding(
              padding:
              const EdgeInsets.all(
                18,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color:
                    Color(0xFF673AB7),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      'Employees assigned to your departments will appear here.',
                      style:
                      const TextStyle(
                        color:
                        Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
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
      String label,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 9,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style:
              const TextStyle(
                color:
                Colors.black54,
                fontSize: 13,
              ),
            ),
          ),
          const Text(':'),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              value.trim().isEmpty
                  ? '-'
                  : value,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style:
              const TextStyle(
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
  // STAT CARD
  // =============================================================

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 0,
      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          18,
        ),
        side:
        const BorderSide(
          color: Colors.black12,
        ),
      ),
      child: Padding(
        padding:
        const EdgeInsets.all(
          18,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
              color:
              const Color(
                0xFF673AB7,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              value,
              style:
              const TextStyle(
                fontSize: 26,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style:
              const TextStyle(
                color:
                Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}