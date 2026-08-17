// ===============================================================
// Flutter HRMS Pro
// Supervisor Dashboard
//
// Version : 2.4.0
//
// UI Improvements:
// - Theme aware
// - Light / Dark mode support
// - Responsive layout
// - Desktop / Tablet / Mobile friendly
// - Modern cards
// - Improved spacing & typography
//
// Functionality: UNCHANGED
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
  // RESPONSIVE CONTENT WIDTH
  // =============================================================

  double _contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1400) {
      return 1200;
    }

    if (width >= 1000) {
      return 1100;
    }

    return double.infinity;
  }

  // =============================================================
  // RESPONSIVE PADDING
  // =============================================================

  EdgeInsets _pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return const EdgeInsets.all(14);
    }

    if (width < 1000) {
      return const EdgeInsets.all(20);
    }

    return const EdgeInsets.symmetric(
      horizontal: 28,
      vertical: 22,
    );
  }

  // =============================================================
  // SUMMARY CARD
  // =============================================================

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(.10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            // ===================================================
            // ICON
            // ===================================================

            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 27,
              ),
            ),

            const SizedBox(width: 14),

            // ===================================================
            // TEXT
            // ===================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface
                          .withOpacity(.60),
                      fontSize: 12,
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
  // SUMMARY GRID
  // =============================================================

  Widget _buildSummaryGrid(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    int columns;

    if (width >= 1100) {
      columns = 4;
    } else if (width >= 700) {
      columns = 2;
    } else {
      columns = 1;
    }

    const spacing = 12.0;

    final cards = [
      _buildCard(
        context: context,
        icon: Icons.apartment_outlined,
        title: 'Departments',
        value: '0',
        color: Colors.blue,
      ),
      _buildCard(
        context: context,
        icon: Icons.badge_outlined,
        title: 'Designations',
        value: '0',
        color: Colors.orange,
      ),
      _buildCard(
        context: context,
        icon: Icons.people_outline,
        title: 'Employees',
        value: '0',
        color: Colors.green,
      ),
      _buildCard(
        context: context,
        icon: Icons.manage_accounts_outlined,
        title: 'Employee Accounts',
        value: '0',
        color: Colors.purple,
      ),
    ];

    if (columns == 1) {
      return Column(
        children: cards
            .map(
              (card) => Padding(
            padding:
            const EdgeInsets.only(bottom: spacing),
            child: card,
          ),
        )
            .toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio:
        width >= 1100 ? 2.15 : 2.35,
      ),
      itemBuilder: (_, index) {
        return cards[index];
      },
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
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(.10),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                // =================================================
                // ICON
                // =================================================

                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withOpacity(.09),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 14),

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
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme
                              .onSurface
                              .withOpacity(.56),
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: colorScheme.onSurface
                      .withOpacity(.35),
                ),
              ],
            ),
          ),
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

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(.10),
        ),
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primary
                        .withOpacity(.10),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.verified_user_outlined,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login Information',
                        style: TextStyle(
                          color:
                          colorScheme.onSurface,
                          fontSize: 17,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        'Current account information',
                        style: TextStyle(
                          color: colorScheme
                              .onSurface
                              .withOpacity(.55),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ===================================================
            // INFORMATION
            // ===================================================

            _infoRow(
              context: context,
              icon: Icons.person_outline,
              label: 'Login Name',
              value: user.loginName,
            ),

            _infoRow(
              context: context,
              icon: Icons.account_circle_outlined,
              label: 'Login User',
              value: user.loginUser,
            ),

            _infoRow(
              context: context,
              icon:
              Icons.admin_panel_settings_outlined,
              label: 'Role',
              value: user.role.name,
            ),

            if (user.companyName != null &&
                user.companyName!
                    .trim()
                    .isNotEmpty)
              _infoRow(
                context: context,
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
                BorderRadius.circular(13),
                border: Border.all(
                  color:
                  Colors.green.withOpacity(.15),
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
                      style: TextStyle(
                        color:
                        colorScheme.onSurface,
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
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding:
      const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: colorScheme.onSurface
                .withOpacity(.55),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurface
                    .withOpacity(.55),
                fontSize: 12,
              ),
            ),
          ),

          Text(
            ':',
            style: TextStyle(
              color: colorScheme.onSurface
                  .withOpacity(.35),
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
              style: TextStyle(
                color:
                colorScheme.onSurface,
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
  // SECTION TITLE
  // =============================================================

  Widget _sectionTitle(
      BuildContext context, {
        required String title,
        String? subtitle,
      }) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              color: colorScheme.onSurface
                  .withOpacity(.55),
              fontSize: 11,
            ),
          ),
        ],
      ],
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final pagePadding =
    _pagePadding(context);

    return Scaffold(
      backgroundColor:
      colorScheme.surface,

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

      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth:
            _contentMaxWidth(context),
          ),
          child: ListView(
            padding: pagePadding,
            children: [
              // =================================================
              // WELCOME
              // =================================================

              Text(
                'Welcome ${user.displayName}',
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                  colorScheme.onSurface,
                  fontSize: 25,
                  fontWeight:
                  FontWeight.w800,
                  letterSpacing: -.4,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'HRMS Pro Supervisor Management Panel',
                style: TextStyle(
                  color: colorScheme.onSurface
                      .withOpacity(.58),
                  fontSize: 13,
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

              const SizedBox(height: 24),

              // =================================================
              // COMPANY OVERVIEW
              // =================================================

              _sectionTitle(
                context,
                title: 'Company Overview',
                subtitle:
                'Quick overview of company resources',
              ),

              const SizedBox(height: 12),

              _buildSummaryGrid(context),

              const SizedBox(height: 26),

              // =================================================
              // COMPANY MANAGEMENT
              // =================================================

              _sectionTitle(
                context,
                title: 'Company Management',
                subtitle:
                'Manage and view company operations',
              ),

              const SizedBox(height: 12),

              // =================================================
              // ATTENDANCE
              // =================================================

              _buildMenu(
                context,
                icon: Icons.apartment_outlined,
                title: 'Attendance',
                subtitle: 'Attendance Report',
                onTap: () {
                  context.push(
                    RoutePaths.departments,
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}