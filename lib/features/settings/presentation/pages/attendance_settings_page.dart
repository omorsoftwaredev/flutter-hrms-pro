// ===============================================================
// Flutter HRMS Pro
// Attendance Settings Page
//
// Responsive + Theme Aware
// Mobile / Tablet / Desktop
//
// Version : 2.0.0
//
// Features:
// - Fully Theme Aware
// - Light / Dark Theme Support
// - Responsive Layout
// - Company automatically determined from logged-in user
// - Working Days
// - Attendance Rules
// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

class AttendanceSettingsPage extends StatelessWidget {
  const AttendanceSettingsPage({
    super.key,
  });

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),

        title: Text(
          'Attendance Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final width = constraints.maxWidth;

            final horizontalPadding = width >= 1200
                ? 40.0
                : width >= 700
                ? 24.0
                : 16.0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                32,
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
                      // =================================================
                      // HEADER
                      // =================================================

                      _buildHeader(context),

                      const SizedBox(
                        height: 20,
                      ),

                      // =================================================
                      // SETTINGS
                      // =================================================

                      _buildSettingsLayout(
                        context,
                        width,
                      ),
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

  // =============================================================
  // SETTINGS LAYOUT
  // =============================================================

  Widget _buildSettingsLayout(
      BuildContext context,
      double width,
      ) {
    final bool isDesktop = width >= 900;

    if (isDesktop) {
      return Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildWorkingDaysCard(
              context,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: _buildAttendanceRulesCard(
              context,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildWorkingDaysCard(
          context,
        ),

        const SizedBox(
          height: 14,
        ),

        _buildAttendanceRulesCard(
          context,
        ),
      ],
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: colorScheme.outlineVariant,
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
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              color: colorScheme.primary,

              borderRadius:
              BorderRadius.circular(16),
            ),

            child: Icon(
              Icons.fact_check_outlined,
              size: 28,
              color: colorScheme.onPrimary,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          // =======================================================
          // TEXT
          // =======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  'Attendance Settings',
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w600,
                    color:
                    colorScheme.onPrimaryContainer,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  'Configure attendance preferences for your company.',
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: colorScheme
                        .onPrimaryContainer
                        .withValues(
                      alpha: 0.75,
                    ),
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

  // =============================================================
  // WORKING DAYS
  // =============================================================

  Widget _buildWorkingDaysCard(
      BuildContext context,
      ) {
    return _SettingsCard(
      context: context,

      icon: Icons.calendar_month_outlined,

      title: 'Working Days',

      subtitle:
      'Configure your company weekly working schedule.',

      onTap: () {
        context.push(
          RoutePaths.workingDaysSettings,
        );
      },

      children: const [
        _PreviewItem(
          icon: Icons.date_range_outlined,
          title: 'Weekly Schedule',
          subtitle:
          'Set which days are considered working days.',
        ),
      ],
    );
  }

  // =============================================================
  // ATTENDANCE RULES
  // =============================================================

  Widget _buildAttendanceRulesCard(
      BuildContext context,
      ) {
    return _SettingsCard(
      context: context,

      icon: Icons.rule_outlined,

      title: 'Attendance Rules',

      subtitle:
      'Configure attendance timing and basic rules.',

      onTap: () {
        context.push(
          RoutePaths.attendanceRulesSettings,
        );
      },

      children: const [
        _PreviewItem(
          icon: Icons.access_time_outlined,
          title: 'Basic Rules',
          subtitle:
          'Configure attendance timing and basic rules.',
        ),
      ],
    );
  }
}

// ===============================================================
// SETTINGS CARD
// ===============================================================

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.context,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.onTap,
  });

  final BuildContext context;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,

      borderRadius:
      BorderRadius.circular(20),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(20),

        onTap: onTap,

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(20),

            border: Border.all(
              color: colorScheme.outlineVariant,
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // ===================================================
              // HEADER
              // ===================================================

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // =================================================
                  // ICON
                  // =================================================

                  Container(
                    width: 48,
                    height: 48,

                    decoration: BoxDecoration(
                      color:
                      colorScheme.primaryContainer,

                      borderRadius:
                      BorderRadius.circular(14),
                    ),

                    child: Icon(
                      icon,
                      color:
                      colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  // =================================================
                  // TITLE + SUBTITLE
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

                          style: theme
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight:
                            FontWeight.w600,
                            color:
                            colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          subtitle,

                          maxLines: 3,

                          overflow:
                          TextOverflow.ellipsis,

                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  // =================================================
                  // ARROW
                  // =================================================

                  Container(
                    width: 34,
                    height: 34,

                    decoration: BoxDecoration(
                      color: colorScheme
                          .surfaceContainerHighest,

                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons
                          .chevron_right_rounded,

                      color:
                      colorScheme.onSurfaceVariant,

                      size: 21,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 17,
              ),

              // ===================================================
              // DIVIDER
              // ===================================================

              Divider(
                height: 1,
                thickness: 1,
                color:
                colorScheme.outlineVariant,
              ),

              const SizedBox(
                height: 14,
              ),

              // ===================================================
              // PREVIEW ITEMS
              // ===================================================

              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// PREVIEW ITEM
// ===============================================================

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

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        // =========================================================
        // ICON
        // =========================================================

        Container(
          width: 36,
          height: 36,

          decoration: BoxDecoration(
            color:
            colorScheme.secondaryContainer,

            borderRadius:
            BorderRadius.circular(10),
          ),

          child: Icon(
            icon,
            size: 18,
            color:
            colorScheme.onSecondaryContainer,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        // =========================================================
        // TEXT
        // =========================================================

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

              const SizedBox(
                height: 2,
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
                  colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(
          width: 8,
        ),

        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color:
          colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}