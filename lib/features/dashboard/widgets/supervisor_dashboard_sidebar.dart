/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Dashboard Sidebar
///
/// Version : 2.7.0
///
/// Theme Aware:
/// - Light / Dark Theme Support
/// - Uses Theme.of(context).colorScheme
/// - No hard-coded background colors
/// - No hard-coded text colors
/// - No hard-coded primary colors
///
/// UI:
/// - Accordion style parent menu
/// - Only one parent group opens at a time
/// - Previous parent automatically closes
/// - Cleaner child menu separation
/// - Meaningful single-line menu labels
/// - Responsive Drawer
/// - Desktop / Tablet / Mobile friendly
///
/// Functionality:
/// - Theme Settings
/// - Attendance Report
/// - Change Password
/// - Logout
/// - Existing routes preserved
/// - Existing attendance navigation preserved
/// - Existing logout functionality preserved
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/route_paths.dart';

class SupervisorDashboardSidebar
    extends ConsumerStatefulWidget {
  const SupervisorDashboardSidebar({
    super.key,
  });

  @override
  ConsumerState<SupervisorDashboardSidebar> createState() =>
      _SupervisorDashboardSidebarState();
}

class _SupervisorDashboardSidebarState
    extends ConsumerState<SupervisorDashboardSidebar> {
  // =============================================================
  // CURRENTLY OPEN GROUP
  // =============================================================

  String? _expandedGroup = 'Attendance';

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
    final CurrentUser? user =
    ref.watch(currentUserProvider);

    // ===========================================================
    // USER LOADING
    // ===========================================================

    if (user == null) {
      return Drawer(
        width: _drawerWidth(context),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      width: _drawerWidth(context),
      backgroundColor: colorScheme.surface,
      elevation: 8,
      child: SafeArea(
        child: Column(
          children: [
            // ===================================================
            // USER HEADER
            // ===================================================

            _buildUserHeader(
              context,
              user,
            ),

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
                    color: colorScheme.primary,
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
                    ],
                  ),

                  // =================================================
                  // ATTENDANCE
                  // =================================================

                  _buildMenuGroup(
                    context,
                    title: 'Attendance',
                    icon: Icons.fact_check_outlined,
                    color: colorScheme.secondary,
                    children: [
                      // =============================================
                      // MOBILE ATTENDANCE
                      // =============================================

                      _buildChildMenuItem(
                        context,
                        icon: Icons.fingerprint,
                        title: 'Mobile Attendance',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.mobileAttendance,
                          );
                        },
                      ),

                      // =============================================
                      // ATTENDANCE REPORT
                      // =============================================

                      _buildChildMenuItem(
                        context,
                        icon: Icons.assessment_outlined,
                        title: 'Own Attendance Report',
                        onTap: () {
                          Navigator.pop(context);

                          final employeeId =
                          user.employeeId.trim();

                          if (employeeId.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
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
                                '?employeeId=$employeeId',
                          );
                        },
                      ),
                      _buildChildMenuItem(
                        context,
                        icon: Icons.assessment_outlined,
                        title: 'Dept Attendance Report',
                        onTap: () {
                          Navigator.pop(context);

                          final supervisorEmployeeId =
                              user.employeeId;

                          final companyId =
                              user.companyId;

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

                          if (companyId.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Company ID not available.',
                                ),
                              ),
                            );

                            return;
                          }

                          context.pushNamed(
                            'supervisorEmployeeAttendanceReport',
                            queryParameters: {
                              'supervisorEmployeeId': supervisorEmployeeId,
                              'companyId': companyId,
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  // =================================================
                  // ACCOUNT
                  // =================================================

                  _buildMenuGroup(
                    context,
                    title: 'Account',
                    icon: Icons.manage_accounts_outlined,
                    color: colorScheme.tertiary,
                    children: [
                      _buildChildMenuItem(
                        context,
                        icon: Icons.lock_reset_outlined,
                        title: 'Change Password',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.changePassword,
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

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
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
  // RESPONSIVE DRAWER WIDTH
  // =============================================================

  double _drawerWidth(
      BuildContext context,
      ) {
    final width = MediaQuery.sizeOf(context).width;

    // ---------------------------------------------------------
    // MOBILE
    // ---------------------------------------------------------

    if (width < 600) {
      return width * .86;
    }

    // ---------------------------------------------------------
    // TABLET
    // ---------------------------------------------------------

    if (width < 1000) {
      return 360;
    }

    // ---------------------------------------------------------
    // DESKTOP
    // ---------------------------------------------------------

    return 380;
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

    final bool isExpanded =
        _expandedGroup == title;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
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
                        milliseconds: 220,
                      ),
                      curve: Curves.easeOut,
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(
                          alpha: isExpanded
                              ? 0.15
                              : 0.09,
                        ),
                        borderRadius:
                        BorderRadius.circular(13),
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
                    // TITLE
                    // =================================================

                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                          fontWeight:
                          FontWeight.w700,
                          color: isExpanded
                              ? color
                              : colorScheme
                              .onSurface,
                        ),
                      ),
                    ),

                    // =================================================
                    // ARROW
                    // =================================================

                    AnimatedRotation(
                      turns:
                      isExpanded ? 0.5 : 0.0,
                      duration:
                      const Duration(
                        milliseconds: 220,
                      ),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons
                            .keyboard_arrow_down_rounded,
                        size: 25,
                        color: isExpanded
                            ? color
                            : colorScheme
                            .onSurfaceVariant,
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
            duration: const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
              padding:
              const EdgeInsets.fromLTRB(
                8,
                0,
                8,
                9,
              ),
              child: Column(
                children: [
                  // =========================================
                  // DIVIDER
                  // =========================================

                  Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 6,
                    ),
                    child: Divider(
                      height: 1,
                      thickness: 0.8,
                      color:
                      color.withValues(
                        alpha: 0.14,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

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
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
              BorderRadius.circular(13),
              border: Border.all(
                color:
                colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                // =================================================
                // ICON
                // =================================================

                Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    color:
                    colorScheme.primaryContainer,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color:
                    colorScheme
                        .onPrimaryContainer,
                    size: 19,
                  ),
                ),

                const SizedBox(
                  width: 11,
                ),

                // =================================================
                // TITLE
                // =================================================

                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w600,
                      color:
                      colorScheme.onSurface,
                    ),
                  ),
                ),

                // =================================================
                // ARROW
                // =================================================

                Icon(
                  Icons
                      .chevron_right_rounded,
                  size: 20,
                  color: colorScheme
                      .onSurfaceVariant,
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
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    final Color errorColor =
        colorScheme.error;

    return Padding(
      padding:
      const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        10,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
          BorderRadius.circular(14),
          onTap: () async {
            Navigator.pop(context);

            // -------------------------------------------------
            // LOGOUT AUTH
            // -------------------------------------------------

            await ref
                .read(
              authRepositoryProvider,
            )
                .logout();

            // -------------------------------------------------
            // CLEAR CURRENT USER
            // -------------------------------------------------

            ref
                .read(
              currentUserProvider
                  .notifier,
            )
                .logout();

            // -------------------------------------------------
            // NAVIGATE LOGIN
            // -------------------------------------------------

            if (context.mounted) {
              context.go(
                RoutePaths.login,
              );
            }
          },
          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 9,
            ),
            decoration:
            BoxDecoration(
              color:
              errorColor.withValues(
                alpha: .07,
              ),
              borderRadius:
              BorderRadius.circular(14),
              border: Border.all(
                color:
                errorColor.withValues(
                  alpha: .18,
                ),
              ),
            ),
            child: Row(
              children: [
                // ===============================================
                // LOGOUT ICON
                // ===============================================

                Container(
                  width: 40,
                  height: 40,
                  decoration:
                  BoxDecoration(
                    color:
                    errorColor.withValues(
                      alpha: .10,
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: errorColor,
                    size: 21,
                  ),
                ),

                const SizedBox(
                  width: 11,
                ),

                // ===============================================
                // LOGOUT TEXT
                // ===============================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logout',
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: errorColor,
                          fontSize: 13.5,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(
                        height: 3,
                      ),

                      Text(
                        'Sign out from your account',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                // ===============================================
                // ARROW
                // ===============================================

                Icon(
                  Icons
                      .chevron_right_rounded,
                  size: 20,
                  color: errorColor,
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
      BuildContext context,
      CurrentUser user,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String displayName =
    user.displayName.trim().isNotEmpty
        ? user.displayName
        : 'Supervisor';

    final Color headerColor =
        colorScheme.primary;

    final Color headerOnColor =
        colorScheme.onPrimary;

    final Color headerMutedColor =
    colorScheme.onPrimary.withValues(
      alpha: .78,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        17,
        20,
        17,
        17,
      ),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius:
        const BorderRadius.only(
          bottomLeft:
          Radius.circular(20),
          bottomRight:
          Radius.circular(20),
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
                  color: headerOnColor,
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),
                child: Center(
                  child: Text(
                    displayName.isEmpty
                        ? '?'
                        : displayName[0]
                        .toUpperCase(),
                    style: theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      color: headerColor,
                      fontWeight:
                      FontWeight.w800,
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
                    // -----------------------------------------
                    // NAME
                    // -----------------------------------------

                    Text(
                      displayName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color:
                        headerOnColor,
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    // -----------------------------------------
                    // LOGIN USER
                    // -----------------------------------------

                    Text(
                      user.loginUser.isEmpty
                          ? 'Supervisor Account'
                          : user.loginUser,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color:
                        headerMutedColor,
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
              Icon(
                Icons
                    .verified_user_outlined,
                color: headerOnColor,
                size: 17,
              ),

              const SizedBox(
                width: 7,
              ),

              Text(
                'Login Information',
                style: theme
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                  color:
                  headerOnColor,
                  fontSize: 13,
                  fontWeight:
                  FontWeight.w700,
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
            context,
            icon:
            Icons.person_outline,
            label: 'Login Name',
            value: user.loginName,
          ),

          // =====================================================
          // LOGIN USER
          // =====================================================

          _infoRow(
            context,
            icon:
            Icons.account_circle_outlined,
            label: 'Login User',
            value: user.loginUser,
          ),

          // =====================================================
          // ROLE
          // =====================================================

          _infoRow(
            context,
            icon: Icons
                .admin_panel_settings_outlined,
            label: 'Role',
            value: user.role.name,
          ),

          // =====================================================
          // EMPLOYEE
          // =====================================================

          if (user.employeeName != null &&
              user.employeeName!
                  .trim()
                  .isNotEmpty)
            _infoRow(
              context,
              icon:
              Icons.badge_outlined,
              label: 'Employee',
              value: user.employeeName!,
            ),

          // =====================================================
          // COMPANY
          // =====================================================

          if (user.companyName != null &&
              user.companyName!
                  .trim()
                  .isNotEmpty)
            _infoRow(
              context,
              icon:
              Icons.business_outlined,
              label: 'Company',
              value: user.companyName!,
            )
          else if (user.companyId
              .isNotEmpty)
            _infoRow(
              context,
              icon:
              Icons.business_outlined,
              label: 'Company ID',
              value: user.companyId,
            ),

          // =====================================================
          // DEPARTMENT
          // =====================================================

          if (user.departmentName != null &&
              user.departmentName!
                  .trim()
                  .isNotEmpty)
            _infoRow(
              context,
              icon:
              Icons.account_tree_outlined,
              label: 'Department',
              value:
              user.departmentName!,
            ),

          // =====================================================
          // DESIGNATION
          // =====================================================

          if (user.designationName != null &&
              user.designationName!
                  .trim()
                  .isNotEmpty)
            _infoRow(
              context,
              icon:
              Icons.work_outline,
              label: 'Designation',
              value:
              user.designationName!,
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
              headerOnColor.withValues(
                alpha: .12,
              ),
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security_outlined,
                  color: headerOnColor,
                  size: 16,
                ),

                const SizedBox(
                  width: 7,
                ),

                Expanded(
                  child: Text(
                    '${user.permissions.length} permissions available',
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color:
                      headerOnColor,
                      fontSize: 11,
                    ),
                  ),
                ),

                Icon(
                  Icons
                      .check_circle_outline,
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
    final colorScheme =
        Theme.of(context).colorScheme;

    final Color onHeader =
        colorScheme.onPrimary;

    final Color muted =
    colorScheme.onPrimary
        .withValues(alpha: .72);

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
            onHeader.withValues(
              alpha: .85,
            ),
            size: 15,
          ),

          const SizedBox(
            width: 7,
          ),

          SizedBox(
            width: 82,
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: muted,
                fontSize: 10.5,
              ),
            ),
          ),

          Text(
            ':',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
              onHeader.withValues(
                alpha: .70,
              ),
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
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: onHeader,
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
}