/// ===============================================================
/// Flutter HRMS Pro
///
/// Settings Page
///
/// Version : 2.0.0
///
/// Features:
/// - Fully theme aware
/// - Light / Dark / System compatible
/// - Responsive settings layout
/// - Mobile / Tablet / Desktop
/// - Appearance
/// - Attendance Settings
/// - Existing routes preserved
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // ===========================================================
      // APP BAR
      // ===========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            context.pop();
          },
        ),

        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),

      // ===========================================================
      // BODY
      // ===========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final width = constraints.maxWidth;

            // =====================================================
            // RESPONSIVE BREAKPOINTS
            // =====================================================

            final bool isDesktop = width >= 900;

            final double horizontalPadding;

            if (width >= 1200) {
              horizontalPadding = 40;
            } else if (width >= 600) {
              horizontalPadding = 24;
            } else {
              horizontalPadding = 12;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1100,
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      // =========================================
                      // HEADER
                      // =========================================

                      _buildPageHeader(context),

                      const SizedBox(height: 20),

                      // =========================================
                      // RESPONSIVE CONTENT
                      // =========================================

                      if (isDesktop)
                        _buildDesktopLayout(context)
                      else
                        _buildMobileLayout(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===============================================================
  // PAGE HEADER
  // ===============================================================

  Widget _buildPageHeader(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: colorScheme.primaryContainer
            .withOpacity(0.45),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: colorScheme.outlineVariant
              .withOpacity(0.65),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // =======================================================
          // ICON
          // =======================================================

          Container(
            width: 54,
            height: 54,

            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withOpacity(0.12),

              borderRadius:
              BorderRadius.circular(15),
            ),

            alignment: Alignment.center,

            child: Icon(
              Icons.settings_outlined,
              color: colorScheme.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          // =======================================================
          // TEXT
          // =======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  'Settings',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.w700,
                    color:
                    colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Manage your application preferences and defaults.',
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // DESKTOP LAYOUT
  // ===============================================================

  Widget _buildDesktopLayout(
      BuildContext context,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Expanded(
          child: _buildAppearanceCard(
            context,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _buildAttendanceSettingsCard(
            context,
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // MOBILE / TABLET LAYOUT
  // ===============================================================

  Widget _buildMobileLayout(
      BuildContext context,
      ) {
    return Column(
      children: [
        _buildAppearanceCard(
          context,
        ),

        const SizedBox(height: 14),

        _buildAttendanceSettingsCard(
          context,
        ),
      ],
    );
  }

  // ===============================================================
  // APPEARANCE
  // ===============================================================

  Widget _buildAppearanceCard(
      BuildContext context,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return _SettingsCard(
      icon: Icons.palette_outlined,
      title: 'Appearance',
      subtitle:
      'Customize the application appearance.',
      iconColor: colorScheme.primary,
      onTap: () {
        context.push(
          RoutePaths.appearanceSettings,
        );
      },
      children: const [
        _PreviewItem(
          icon: Icons.brightness_6_outlined,
          title: 'Theme',
          subtitle:
          'Light / Dark / System',
        ),
      ],
    );
  }

  // ===============================================================
  // ATTENDANCE SETTINGS
  // ===============================================================

  Widget _buildAttendanceSettingsCard(
      BuildContext context,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return _SettingsCard(
      icon: Icons.fact_check_outlined,
      title: 'Attendance Settings',
      subtitle:
      'Configure working days and attendance rules.',
      iconColor: colorScheme.secondary,
      onTap: () {
        context.push(
          RoutePaths.attendanceSettings,
        );
      },
      children: const [
        _PreviewItem(
          icon: Icons.calendar_month_outlined,
          title: 'Working Days',
          subtitle:
          'Configure weekly working days',
        ),

        SizedBox(height: 10),

        _PreviewItem(
          icon: Icons.weekend_outlined,
          title: 'Weekend',
          subtitle:
          'Configure weekly weekend',
        ),

        SizedBox(height: 10),

        _PreviewItem(
          icon: Icons.rule_outlined,
          title: 'Attendance Rules',
          subtitle:
          'Basic attendance preferences',
        ),
      ],
    );
  }
}

// ===================================================================
// SETTINGS CARD
// ===================================================================

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.children,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final List<Widget> children;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,

      borderRadius:
      BorderRadius.circular(18),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(18),

        onTap: onTap,

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: colorScheme.surface,

            borderRadius:
            BorderRadius.circular(18),

            border: Border.all(
              color:
              colorScheme.outlineVariant,
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // =================================================
              // CARD HEADER
              // =================================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // =============================================
                  // ICON
                  // =============================================

                  Container(
                    width: 46,
                    height: 46,

                    decoration: BoxDecoration(
                      color: iconColor
                          .withOpacity(0.12),

                      borderRadius:
                      BorderRadius.circular(
                        13,
                      ),
                    ),

                    alignment: Alignment.center,

                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // =============================================
                  // TITLE + SUBTITLE
                  // =============================================

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

                          style: theme
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight:
                            FontWeight.w700,
                            color:
                            colorScheme
                                .onSurface,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,

                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color:
                            colorScheme
                                .onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // =============================================
                  // ARROW
                  // =============================================

                  Icon(
                    Icons.chevron_right_rounded,
                    color:
                    colorScheme
                        .onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // =================================================
              // DIVIDER
              // =================================================

              Divider(
                height: 1,
                color:
                colorScheme.outlineVariant,
              ),

              const SizedBox(height: 14),

              // =================================================
              // PREVIEW ITEMS
              // =================================================

              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// PREVIEW ITEM
// ===================================================================

class _PreviewItem extends StatelessWidget {
  const _PreviewItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),

      decoration: BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest
            .withOpacity(0.35),

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color:
          colorScheme.outlineVariant
              .withOpacity(0.55),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // =====================================================
          // ICON
          // =====================================================

          Container(
            width: 34,
            height: 34,

            decoration: BoxDecoration(
              color: colorScheme.primary
                  .withOpacity(0.10),

              borderRadius:
              BorderRadius.circular(9),
            ),

            alignment: Alignment.center,

            child: Icon(
              icon,
              size: 18,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(width: 10),

          // =====================================================
          // TEXT
          // =====================================================

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

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    colorScheme
                        .onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}