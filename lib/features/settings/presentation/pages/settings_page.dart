/// ===============================================================
/// Flutter HRMS Pro
///
/// Settings Page
///
/// Version : 1.0.0
///
/// Features:
/// - Responsive settings layout
/// - Appearance
/// - Company Settings
/// - Attendance Settings
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color primaryColor = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            context.pop();
          },
        ),

        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // =====================================================
            // RESPONSIVE BREAKPOINT
            // =====================================================

            final isDesktop = width >= 900;

            final horizontalPadding = width >= 1200
                ? 40.0
                : width >= 600
                ? 24.0
                : 12.0;

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
                      _buildPageHeader(context),

                      const SizedBox(height: 20),

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

  // =============================================================
  // PAGE HEADER
  // =============================================================

  Widget _buildPageHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: primaryColor,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Manage your application preferences and defaults.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
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
  // DESKTOP
  // =============================================================

  Widget _buildDesktopLayout(
      BuildContext context,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildAppearanceCard(context),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _buildAttendanceSettingsCard(context),
        ),
      ],
    );
  }

  // =============================================================
  // MOBILE / TABLET
  // =============================================================

  Widget _buildMobileLayout(
      BuildContext context,
      ) {
    return Column(
      children: [
        _buildAppearanceCard(context),

        const SizedBox(height: 14),

        _buildAttendanceSettingsCard(context),
      ],
    );
  }

  // =============================================================
  // APPEARANCE
  // =============================================================

  Widget _buildAppearanceCard(
      BuildContext context,
      ) {
    return _SettingsCard(
      icon: Icons.palette_outlined,
      title: 'Appearance',
      subtitle: 'Customize the application appearance.',
      iconColor: Colors.deepPurple,
      onTap: () {
        context.push(
          RoutePaths.appearanceSettings,
        );
      },
      children: const [
        _PreviewItem(
          icon: Icons.brightness_6_outlined,
          title: 'Theme',
          subtitle: 'Light / Dark / System',
        ),
      ],
    );
  }

  // =============================================================
  // ATTENDANCE SETTINGS
  // =============================================================

  Widget _buildAttendanceSettingsCard(
      BuildContext context,
      ) {
    return _SettingsCard(
      icon: Icons.fact_check_outlined,
      title: 'Attendance Settings',
      subtitle: 'Configure working days and attendance rules.',
      iconColor: Colors.teal,
      onTap: () {
        context.push(
          RoutePaths.attendanceSettings,
        );
      },
      children: const [
        _PreviewItem(
          icon: Icons.calendar_month_outlined,
          title: 'Working Days',
          subtitle: 'Configure weekly working days',
        ),
        SizedBox(height: 10),
        _PreviewItem(
          icon: Icons.weekend_outlined,
          title: 'Weekend',
          subtitle: 'Configure weekly weekend',
        ),
        SizedBox(height: 10),
        _PreviewItem(
          icon: Icons.rule_outlined,
          title: 'Attendance Rules',
          subtitle: 'Basic attendance preferences',
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
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
                      color: iconColor.withOpacity(.10),
                      borderRadius:
                      BorderRadius.circular(13),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color:
                            Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(height: 1),

              const SizedBox(height: 14),

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
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade600,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}