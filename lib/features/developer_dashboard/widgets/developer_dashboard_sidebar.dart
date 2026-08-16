// ===============================================================
// Flutter HRMS Pro
// Developer Dashboard Sidebar
//
// Version : 2.5.0
//
// Responsive + Theme Aware
// Mobile / Tablet / Desktop
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/route_paths.dart';

class DeveloperDashboardSidebar extends ConsumerWidget {
  const DeveloperDashboardSidebar({
    super.key,
  });

  // =============================================================
  // RESPONSIVE DRAWER WIDTH
  // =============================================================

  double _drawerWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    // -----------------------------------------------------------
    // Mobile
    // -----------------------------------------------------------

    if (width < 600) {
      return width * 0.86 > 360
          ? 360
          : width * 0.86;
    }

    // -----------------------------------------------------------
    // Tablet
    // -----------------------------------------------------------

    if (width < 1000) {
      return 380;
    }

    // -----------------------------------------------------------
    // Desktop
    // -----------------------------------------------------------

    return 400;
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // =========================================================
    // USER LOADING
    // =========================================================

    if (user == null) {
      return Drawer(
        width: _drawerWidth(context),
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

      child: SafeArea(
        child: Column(
          children: [

            // =================================================
            // LOGIN INFORMATION
            // =================================================

            _buildUserHeader(
              context,
              user,
            ),

            // =================================================
            // MENU
            // =================================================

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                children: [

                  // =============================================
                  // SECTION TITLE
                  // =============================================

                  _buildSectionTitle(
                    context,
                    icon: Icons.business_center_outlined,
                    title: 'Company Management',
                  ),

                  // =============================================
                  // COMPANY MANAGEMENT
                  // =============================================

                  _buildMenuItem(
                    context,
                    icon: Icons.business_outlined,
                    title: 'Company Management',
                    subtitle:
                    'Company Setup & Maintenance',
                    onTap: () {
                      Navigator.pop(context);

                      context.go(
                        RoutePaths.companies,
                      );
                    },
                  ),

                  // =============================================
                  // COMPANY ACCOUNTS
                  // =============================================

                  _buildMenuItem(
                    context,
                    icon:
                    Icons.manage_accounts_outlined,
                    title: 'Company Accounts',
                    subtitle:
                    'Login & Account Management',
                    onTap: () {
                      Navigator.pop(context);

                      context.go(
                        RoutePaths.companyAccounts,
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // =============================================
                  // SECTION TITLE
                  // =============================================

                  _buildSectionTitle(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Application',
                  ),

                  // =============================================
                  // THEME & APPEARANCE
                  // =============================================

                  _buildMenuItem(
                    context,
                    icon: Icons.palette_outlined,
                    title: 'Theme & Appearance',
                    subtitle:
                    'Customize app theme and appearance',
                    onTap: () {
                      Navigator.pop(context);

                      context.push(
                        RoutePaths.themeSettings,
                      );
                    },
                  ),
                ],
              ),
            ),

            // ===================================================
            // LOGOUT
            // ===================================================

            Divider(
              height: 1,
              color: colorScheme.outlineVariant,
            ),

            _buildLogoutItem(
              context,
              ref,
            ),
          ],
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

      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        18,
      ),

      decoration: BoxDecoration(
        color: colorScheme.primary,

        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),

        boxShadow: [
          BoxShadow(
            color:
            colorScheme.shadow.withValues(
              alpha: 0.10,
            ),
            blurRadius: 14,
            offset: const Offset(
              0,
              5,
            ),
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

                decoration: BoxDecoration(
                  color:
                  colorScheme.onPrimary,
                  borderRadius:
                  BorderRadius.circular(16),
                ),

                child: Center(
                  child: Text(
                    initial,

                    style:
                    theme.textTheme.headlineSmall
                        ?.copyWith(
                      color:
                      colorScheme.primary,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // -------------------------------------------------
              // NAME
              // -------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      displayName.isEmpty
                          ? 'Developer'
                          : displayName,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      theme.textTheme.titleMedium
                          ?.copyWith(
                        color:
                        colorScheme.onPrimary,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      loginIdentifier.isEmpty
                          ? 'Developer Account'
                          : loginIdentifier,

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      theme.textTheme.bodySmall
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

          const SizedBox(height: 18),

          // =====================================================
          // LOGIN INFORMATION TITLE
          // =====================================================

          Row(
            children: [

              Icon(
                Icons.verified_user_outlined,
                color:
                colorScheme.onPrimary,
                size: 17,
              ),

              const SizedBox(width: 7),

              Text(
                'Login Information',

                style:
                theme.textTheme.labelLarge
                    ?.copyWith(
                  color:
                  colorScheme.onPrimary,
                  fontWeight:
                  FontWeight.w800,
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
            icon:
            Icons.admin_panel_settings_outlined,
            label: 'Role',
            value: user.role.name,
          ),

          // =====================================================
          // DEVELOPER
          // =====================================================

          if (displayName.isNotEmpty)
            _infoRow(
              context,
              icon: Icons.code_outlined,
              label: 'Developer',
              value: displayName,
            ),

          const SizedBox(height: 8),

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
              colorScheme.onPrimary
                  .withValues(
                alpha: 0.12,
              ),

              borderRadius:
              BorderRadius.circular(10),

              border: Border.all(
                color:
                colorScheme.onPrimary
                    .withValues(
                  alpha: 0.10,
                ),
              ),
            ),

            child: Row(
              children: [

                Icon(
                  Icons.security_outlined,
                  color:
                  colorScheme.onPrimary,
                  size: 16,
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    '${user.permissions.length} permissions available',

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,

                    style:
                    theme.textTheme.bodySmall
                        ?.copyWith(
                      color:
                      colorScheme.onPrimary,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),

                Icon(
                  Icons.check_circle_outline,
                  color:
                  colorScheme.onPrimary,
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
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color:
            colorScheme.onPrimary
                .withValues(
              alpha: 0.85,
            ),
            size: 15,
          ),

          const SizedBox(width: 7),

          SizedBox(
            width: 82,

            child: Text(
              label,

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style:
              theme.textTheme.bodySmall
                  ?.copyWith(
                color: colorScheme.onPrimary
                    .withValues(
                  alpha: 0.70,
                ),
                fontSize: 10.5,
              ),
            ),
          ),

          Text(
            ':',

            style:
            theme.textTheme.bodySmall
                ?.copyWith(
              color: colorScheme.onPrimary
                  .withValues(
                alpha: 0.70,
              ),
              fontSize: 11,
            ),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Text(
              value.trim().isEmpty
                  ? '-'
                  : value.trim(),

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style:
              theme.textTheme.bodySmall
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

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _buildSectionTitle(
      BuildContext context, {
        required IconData icon,
        required String title,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        6,
      ),

      child: Row(
        children: [

          Icon(
            icon,
            size: 16,
            color:
            colorScheme.onSurfaceVariant,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(
              title,

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style:
              theme.textTheme.labelMedium
                  ?.copyWith(
                color:
                colorScheme.onSurfaceVariant,
                fontWeight:
                FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // MENU ITEM
  // =============================================================

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),

      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,

        color: Colors.transparent,

        child: InkWell(
          borderRadius:
          BorderRadius.circular(14),

          onTap: onTap,

          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),

            child: Row(
              children: [

                // ===============================================
                // ICON
                // ===============================================

                Container(
                  width: 42,
                  height: 42,

                  decoration: BoxDecoration(
                    color: colorScheme
                        .primaryContainer,

                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: Icon(
                    icon,
                    color: colorScheme
                        .onPrimaryContainer,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                // ===============================================
                // TITLE + SUBTITLE
                // ===============================================

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

                        style:
                        theme.textTheme
                            .titleSmall
                            ?.copyWith(
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        subtitle,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style:
                        theme.textTheme
                            .bodySmall
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ===============================================
                // ARROW
                // ===============================================

                Icon(
                  Icons.chevron_right_rounded,
                  size: 21,
                  color:
                  colorScheme
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
  // LOGOUT ITEM
  // =============================================================

  Widget _buildLogoutItem(
      BuildContext context,
      WidgetRef ref,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        7,
        8,
        8,
      ),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(14),

        onTap: () async {
          Navigator.pop(context);

          // -----------------------------------------------------
          // LOGOUT AUTH
          // -----------------------------------------------------

          await ref
              .read(authRepositoryProvider)
              .logout();

          // -----------------------------------------------------
          // CLEAR CURRENT USER
          // -----------------------------------------------------

          ref
              .read(
            currentUserProvider.notifier,
          )
              .logout();

          // -----------------------------------------------------
          // NAVIGATE LOGIN
          // -----------------------------------------------------

          if (context.mounted) {
            context.go(
              RoutePaths.login,
            );
          }
        },

        child: Padding(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),

          child: Row(
            children: [

              // ===============================================
              // LOGOUT ICON
              // ===============================================

              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: colorScheme
                      .errorContainer,

                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),

                child: Icon(
                  Icons.logout_rounded,
                  color:
                  colorScheme
                      .onErrorContainer,
                  size: 21,
                ),
              ),

              const SizedBox(width: 12),

              // ===============================================
              // TEXT
              // ===============================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      'Logout',

                      style:
                      theme.textTheme
                          .titleSmall
                          ?.copyWith(
                        color:
                        colorScheme.error,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Sign out from your account',

                      maxLines: 1,

                      overflow:
                      TextOverflow.ellipsis,

                      style:
                      theme.textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                size: 21,
                color:
                colorScheme.error,
              ),
            ],
          ),
        ),
      ),
    );
  }
}