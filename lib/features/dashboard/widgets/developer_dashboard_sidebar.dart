// ===============================================================
// Flutter HRMS Pro
// Developer Dashboard Sidebar
//
// Version : 2.6.0
//
// Theme Aware:
// - Light / Dark Theme Support
// - Uses Theme.of(context).colorScheme
// - No hard-coded background colors
// - No hard-coded text colors
// - No hard-coded primary colors
//
// UI:
// - Accordion style parent menu
// - Only one parent group opens at a time
// - Previous parent automatically closes
// - Cleaner child menu separation
// - Responsive Drawer
// - Desktop / Tablet / Mobile friendly
//
// Functionality:
// - Theme & Appearance
// - Company Management
// - Company Accounts
// - Logout
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

class DeveloperDashboardSidebar extends ConsumerStatefulWidget {
  const DeveloperDashboardSidebar({
    super.key,
  });

  @override
  ConsumerState<DeveloperDashboardSidebar> createState() =>
      _DeveloperDashboardSidebarState();
}

class _DeveloperDashboardSidebarState
    extends ConsumerState<DeveloperDashboardSidebar> {
  // =============================================================
  // CURRENTLY OPEN GROUP
  // =============================================================

  String? _expandedGroup = 'Application';

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
      String route, {
        bool useGo = false,
      }) {
    Navigator.pop(context);

    if (useGo) {
      context.go(route);
    } else {
      context.push(route);
    }
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final CurrentUser? user = ref.watch(currentUserProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===========================================================
    // USER LOADING
    // ===========================================================

    if (user == null) {
      return Drawer(
        width: _drawerWidth(context),
        backgroundColor: colorScheme.surface,
        child: Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        ),
      );
    }

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
                  // APPLICATION
                  // =================================================

                  _buildMenuGroup(
                    context,
                    title: 'Application',
                    icon: Icons.settings_outlined,
                    color: colorScheme.primary,
                    children: [
                      // =============================================
                      // THEME & APPEARANCE
                      // =============================================

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
                  // COMPANY MANAGEMENT
                  // =================================================

                  _buildMenuGroup(
                    context,
                    title: 'Company Management',
                    icon: Icons.business_center_outlined,
                    color: colorScheme.secondary,
                    children: [
                      // =============================================
                      // COMPANY MANAGEMENT
                      // =============================================

                      _buildChildMenuItem(
                        context,
                        icon: Icons.business_outlined,
                        title: 'Company Management',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.companies,
                            useGo: true,
                          );
                        },
                      ),

                      // =============================================
                      // COMPANY ACCOUNTS
                      // =============================================

                      _buildChildMenuItem(
                        context,
                        icon: Icons.manage_accounts_outlined,
                        title: 'Company Accounts',
                        onTap: () {
                          _navigate(
                            context,
                            RoutePaths.companyAccounts,
                            useGo: true,
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

            _buildLogout(
              context,
            ),
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

    // -----------------------------------------------------------
    // MOBILE
    // -----------------------------------------------------------

    if (width < 600) {
      return width * 0.86 > 360
          ? 360
          : width * 0.86;
    }

    // -----------------------------------------------------------
    // TABLET
    // -----------------------------------------------------------

    if (width < 1000) {
      return 380;
    }

    // -----------------------------------------------------------
    // DESKTOP
    // -----------------------------------------------------------

    return 400;
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
            ? color.withValues(
          alpha: .055,
        )
            : colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(17),
        border: Border.all(
          color: isExpanded
              ? color.withValues(
            alpha: .20,
          )
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
              borderRadius:
              BorderRadius.circular(17),
              onTap: () {
                _toggleGroup(title);
              },
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  12,
                  11,
                  10,
                  11,
                ),
                child: Row(
                  children: [
                    // ===========================================
                    // GROUP ICON
                    // ===========================================

                    AnimatedContainer(
                      duration:
                      const Duration(
                        milliseconds: 220,
                      ),
                      curve: Curves.easeOut,
                      width: 44,
                      height: 44,
                      decoration:
                      BoxDecoration(
                        color:
                        color.withValues(
                          alpha: isExpanded
                              ? .15
                              : .09,
                        ),
                        borderRadius:
                        BorderRadius
                            .circular(
                          13,
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

                    // ===========================================
                    // TITLE
                    // ===========================================

                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow:
                        TextOverflow
                            .ellipsis,
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

                    // ===========================================
                    // ARROW
                    // ===========================================

                    AnimatedRotation(
                      turns: isExpanded
                          ? .5
                          : 0,
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
          // CHILD MENU
          // =====================================================

          AnimatedSize(
            duration:
            const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Padding(
              padding:
              const EdgeInsets
                  .fromLTRB(
                8,
                0,
                8,
                9,
              ),
              child: Column(
                children: [
                  // =======================================
                  // DIVIDER
                  // =======================================

                  Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 6,
                    ),
                    child: Divider(
                      height: 1,
                      thickness: .8,
                      color:
                      color.withValues(
                        alpha: .14,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 7,
                  ),

                  // =======================================
                  // CHILDREN
                  // =======================================

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
    final colorScheme =
        theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Material(
        color: colorScheme.surface,
        borderRadius:
        BorderRadius.circular(13),
        child: InkWell(
          borderRadius:
          BorderRadius.circular(13),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration:
            BoxDecoration(
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
                // ===============================================
                // ICON
                // ===============================================

                Container(
                  width: 37,
                  height: 37,
                  decoration:
                  BoxDecoration(
                    color: colorScheme
                        .primaryContainer,
                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme
                        .onPrimaryContainer,
                    size: 19,
                  ),
                ),

                const SizedBox(
                  width: 11,
                ),

                // ===============================================
                // TITLE
                // ===============================================

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

                // ===============================================
                // ARROW
                // ===============================================

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
    final colorScheme =
        theme.colorScheme;

    // -----------------------------------------------------------
    // Developer display name
    //
    // Priority:
    // 1. fullName
    // 2. loginName
    // -----------------------------------------------------------

    final String displayName =
    user.fullName.trim().isNotEmpty
        ? user.fullName.trim()
        : user.loginName.trim();

    final String initial =
    displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : '?';

    final String loginIdentifier =
    user.email.trim().isNotEmpty
        ? user.email.trim()
        : user.loginUser.trim();

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        18,
      ),
      decoration:
      BoxDecoration(
        color: colorScheme.primary,
        borderRadius:
        const BorderRadius.only(
          bottomLeft:
          Radius.circular(22),
          bottomRight:
          Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(
              alpha: 0.10,
            ),
            blurRadius: 14,
            offset:
            const Offset(0, 5),
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
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              // -------------------------------------------------
              // AVATAR
              // -------------------------------------------------

              Container(
                width: 56,
                height: 56,
                decoration:
                BoxDecoration(
                  color:
                  colorScheme.onPrimary,
                  borderRadius:
                  BorderRadius.circular(
                    16,
                  ),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      color: colorScheme
                          .primary,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // -------------------------------------------------
              // NAME
              // -------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      displayName.isEmpty
                          ? 'Developer'
                          : displayName,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        color: colorScheme
                            .onPrimary,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      loginIdentifier.isEmpty
                          ? 'Developer Account'
                          : loginIdentifier,
                      maxLines: 1,
                      overflow:
                      TextOverflow
                          .ellipsis,
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onPrimary
                            .withValues(
                          alpha: 0.80,
                        ),
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
          // LOGIN INFORMATION TITLE
          // =====================================================

          Row(
            children: [
              Icon(
                Icons
                    .verified_user_outlined,
                color:
                colorScheme.onPrimary,
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
                  colorScheme.onPrimary,
                  fontWeight:
                  FontWeight.w800,
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
            icon: Icons
                .account_circle_outlined,
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
          // DEVELOPER
          // =====================================================

          if (displayName.isNotEmpty)
            _infoRow(
              context,
              icon:
              Icons.code_outlined,
              label: 'Developer',
              value: displayName,
            ),

          const SizedBox(
            height: 8,
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
            decoration:
            BoxDecoration(
              color: colorScheme
                  .onPrimary
                  .withValues(
                alpha: 0.12,
              ),
              borderRadius:
              BorderRadius.circular(
                10,
              ),
              border: Border.all(
                color: colorScheme
                    .onPrimary
                    .withValues(
                  alpha: 0.10,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security_outlined,
                  color: colorScheme
                      .onPrimary,
                  size: 16,
                ),

                const SizedBox(
                  width: 7,
                ),

                Expanded(
                  child: Text(
                    '${user.permissions.length} permissions available',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color:
                      colorScheme
                          .onPrimary,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),

                Icon(
                  Icons
                      .check_circle_outline,
                  color: colorScheme
                      .onPrimary,
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
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

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
            color: colorScheme
                .onPrimary
                .withValues(
              alpha: 0.85,
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
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: colorScheme
                    .onPrimary
                    .withValues(
                  alpha: 0.70,
                ),
                fontSize: 10.5,
              ),
            ),
          ),

          Text(
            ':',
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color: colorScheme
                  .onPrimary
                  .withValues(
                alpha: 0.70,
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
                  : value.trim(),
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                colorScheme.onPrimary,
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