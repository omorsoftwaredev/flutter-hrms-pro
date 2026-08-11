/// ===============================================================
/// Flutter HRMS Pro
///
/// Attendance Settings Page
///
/// Version : 1.0.0
///
/// Features:
/// - Responsive UI
/// - Company is automatically determined from logged-in user
/// - Working Days
/// - Weekend
/// - Attendance Rules
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

class AttendanceSettingsPage extends StatelessWidget {
  const AttendanceSettingsPage({
    super.key,
  });

  static const Color primaryColor = Color(0xFF009688);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            context.pop();
          },
        ),

        title: const Text(
          'Attendance Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
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

            final isDesktop = width >= 900;

            final horizontalPadding = width >= 1200
                ? 40.0
                : width >= 600
                ? 24.0
                : 16.0;

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

                      if (isDesktop)
                        Row(
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


                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildWorkingDaysCard(
                              context,
                            ),

                            const SizedBox(
                              height: 14,
                            ),
                          ],
                        ),

                      const SizedBox(
                        height: 14,
                      ),

                      _buildAttendanceRulesCard(
                        context,
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
        color: colorScheme.primary.withOpacity(
          0.08,
        ),
        borderRadius: BorderRadius.circular(
          18,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(
                0.12,
              ),
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(
              Icons.fact_check_outlined,
              size: 30,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(
            width: 15,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  'Attendance Settings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Configure attendance preferences for your company.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(
                      0.65,
                    ),
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
      subtitle: 'Configure weekly working days.',
      onTap: () {
        context.push(
          RoutePaths.workingDaysSettings,
        );
      },
      children: const [
        _PreviewItem(
          icon: Icons.date_range_outlined,
          title: 'Weekly Schedule',
          subtitle: 'Set which days are working days.',
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
      subtitle: 'Configure basic attendance preferences.',
      onTap: () {
        context.push(
          RoutePaths.attendanceRulesSettings,
        );
      },
      children: const [
        _PreviewItem(
          icon: Icons.access_time_outlined,
          title: 'Basic Rules',
          subtitle: 'Attendance timing and basic rules.',
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
      color: theme.cardColor,

      borderRadius: BorderRadius.circular(
        16,
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(
          16,
        ),

        onTap: onTap,

        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              16,
            ),

            border: Border.all(
              color: theme.dividerColor.withOpacity(
                0.5,
              ),
            ),
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,

                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(
                        0.10,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        13,
                      ),
                    ),

                    child: Icon(
                      icon,
                      color: colorScheme.primary,
                      size: 24,
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
                        Text(
                          title,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,

                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
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

                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface
                                .withOpacity(
                              0.60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurface
                        .withOpacity(
                      0.50,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 16,
              ),

              Divider(
                height: 1,
                color: theme.dividerColor,
              ),

              const SizedBox(
                height: 14,
              ),

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
      children: [
        Icon(
          icon,
          size: 19,
          color: colorScheme.onSurface.withOpacity(
            0.60,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

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

                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
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

                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface
                      .withOpacity(
                    0.60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}