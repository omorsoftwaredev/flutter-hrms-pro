import 'package:flutter/material.dart';

import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_tile.dart';
import '../../../../core/widgets/app_status_chip.dart';

import '../../domain/entities/shift_entity.dart';

class ShiftViewPage extends StatelessWidget {
  const ShiftViewPage({
    super.key,
    required this.shift,
  });

  final ShiftEntity shift;

  // =============================================================
  // WEEKLY OFF DAY
  // =============================================================

  String _weekDay(int? day) {
    switch (day) {
      case 0:
        return 'Sunday';

      case 1:
        return 'Monday';

      case 2:
        return 'Tuesday';

      case 3:
        return 'Wednesday';

      case 4:
        return 'Thursday';

      case 5:
        return 'Friday';

      case 6:
        return 'Saturday';

      default:
        return '-';
    }
  }

  // =============================================================
  // DETAIL SECTION
  // =============================================================

  Widget _buildDetailSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }

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
        title: Text(
          'Shift Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final bool isDesktop = width >= 1000;
            final bool isTablet = width >= 600;

            final double horizontalPadding = isDesktop
                ? 32
                : isTablet
                ? 24
                : 16;

            final double maxContentWidth = isDesktop
                ? 1000
                : isTablet
                ? 850
                : double.infinity;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                32,
              ),

              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxContentWidth,
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // =========================================
                        // HEADER
                        // =========================================

                        AppCard(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop
                                  ? 32
                                  : isTablet
                                  ? 24
                                  : 20,
                              vertical: 28,
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: isDesktop ? 44 : 38,
                                  backgroundColor:
                                  colorScheme.primaryContainer,
                                  child: Icon(
                                    Icons.schedule_rounded,
                                    size: isDesktop ? 46 : 40,
                                    color:
                                    colorScheme.onPrimaryContainer,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  shift.name,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                AppStatusChip(
                                  isActive: shift.isActive,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // =========================================
                        // DESKTOP / TABLET
                        // =========================================

                        if (isDesktop || isTablet)
                          _buildResponsiveSections(
                            context,
                            isDesktop: isDesktop,
                          )
                        else ...[
                          // =======================================
                          // BASIC INFORMATION
                          // =======================================

                          _buildDetailSection(
                            context: context,
                            title: 'Basic Information',
                            icon: Icons.info_outline_rounded,
                            children: [
                              AppDetailTile(
                                title: 'Company ID',
                                value: shift.companyId,
                              ),
                              AppDetailTile(
                                title: 'Shift Name',
                                value: shift.name,
                              ),
                              AppDetailTile(
                                title: 'Description',
                                value: shift.description.isEmpty
                                    ? '-'
                                    : shift.description,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // =======================================
                          // SHIFT TIMING
                          // =======================================

                          _buildDetailSection(
                            context: context,
                            title: 'Shift Timing',
                            icon: Icons.access_time_rounded,
                            children: [
                              AppDetailTile(
                                title: 'Start Time',
                                value: shift.startTime,
                              ),
                              AppDetailTile(
                                title: 'End Time',
                                value: shift.endTime,
                              ),
                              AppDetailTile(
                                title: 'Break Time',
                                value:
                                '${shift.breakMinutes} Minutes',
                              ),
                              AppDetailTile(
                                title: 'Weekly Off',
                                value:
                                _weekDay(shift.weeklyOffDay),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // =======================================
                          // ATTENDANCE RULES
                          // =======================================

                          _buildDetailSection(
                            context: context,
                            title: 'Attendance Rules',
                            icon: Icons.fact_check_outlined,
                            children: [
                              AppDetailTile(
                                title: 'Grace In',
                                value:
                                '${shift.graceInMinutes} Minutes',
                              ),
                              AppDetailTile(
                                title: 'Grace Out',
                                value:
                                '${shift.graceOutMinutes} Minutes',
                              ),
                              AppDetailTile(
                                title: 'Late After',
                                value:
                                '${shift.lateAfterMinutes} Minutes',
                              ),
                              AppDetailTile(
                                title: 'Half Day After',
                                value:
                                '${shift.halfDayAfterMinutes} Minutes',
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // =======================================
                          // SHIFT TYPE
                          // =======================================

                          _buildDetailSection(
                            context: context,
                            title: 'Shift Type',
                            icon: Icons.settings_outlined,
                            children: [
                              AppDetailTile(
                                title: 'Night Shift',
                                value:
                                shift.isNightShift ? 'Yes' : 'No',
                              ),
                              AppDetailTile(
                                title: 'Flexible Shift',
                                value:
                                shift.isFlexible ? 'Yes' : 'No',
                              ),
                              AppDetailTile(
                                title: 'Status',
                                value:
                                shift.isActive
                                    ? 'Active'
                                    : 'Inactive',
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // =======================================
                          // AUDIT INFORMATION
                          // =======================================

                          _buildDetailSection(
                            context: context,
                            title: 'Audit Information',
                            icon: Icons.history_rounded,
                            children: [
                              AppDetailTile(
                                title: 'Created At',
                                value:
                                shift.createdAt.toString(),
                              ),
                              AppDetailTile(
                                title: 'Updated At',
                                value:
                                shift.updatedAt?.toString() ?? '-',
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // RESPONSIVE SECTIONS
  // =============================================================

  Widget _buildResponsiveSections(
      BuildContext context, {
        required bool isDesktop,
      }) {
    final double spacing = 16;

    final basicInformation = _buildDetailSection(
      context: context,
      title: 'Basic Information',
      icon: Icons.info_outline_rounded,
      children: [
        AppDetailTile(
          title: 'Company ID',
          value: shift.companyId,
        ),
        AppDetailTile(
          title: 'Shift Name',
          value: shift.name,
        ),
        AppDetailTile(
          title: 'Description',
          value: shift.description.isEmpty
              ? '-'
              : shift.description,
        ),
      ],
    );

    final shiftTiming = _buildDetailSection(
      context: context,
      title: 'Shift Timing',
      icon: Icons.access_time_rounded,
      children: [
        AppDetailTile(
          title: 'Start Time',
          value: shift.startTime,
        ),
        AppDetailTile(
          title: 'End Time',
          value: shift.endTime,
        ),
        AppDetailTile(
          title: 'Break Time',
          value: '${shift.breakMinutes} Minutes',
        ),
        AppDetailTile(
          title: 'Weekly Off',
          value: _weekDay(shift.weeklyOffDay),
        ),
      ],
    );

    final attendanceRules = _buildDetailSection(
      context: context,
      title: 'Attendance Rules',
      icon: Icons.fact_check_outlined,
      children: [
        AppDetailTile(
          title: 'Grace In',
          value: '${shift.graceInMinutes} Minutes',
        ),
        AppDetailTile(
          title: 'Grace Out',
          value: '${shift.graceOutMinutes} Minutes',
        ),
        AppDetailTile(
          title: 'Late After',
          value: '${shift.lateAfterMinutes} Minutes',
        ),
        AppDetailTile(
          title: 'Half Day After',
          value: '${shift.halfDayAfterMinutes} Minutes',
        ),
      ],
    );

    final shiftType = _buildDetailSection(
      context: context,
      title: 'Shift Type',
      icon: Icons.settings_outlined,
      children: [
        AppDetailTile(
          title: 'Night Shift',
          value: shift.isNightShift ? 'Yes' : 'No',
        ),
        AppDetailTile(
          title: 'Flexible Shift',
          value: shift.isFlexible ? 'Yes' : 'No',
        ),
        AppDetailTile(
          title: 'Status',
          value: shift.isActive ? 'Active' : 'Inactive',
        ),
      ],
    );

    final auditInformation = _buildDetailSection(
      context: context,
      title: 'Audit Information',
      icon: Icons.history_rounded,
      children: [
        AppDetailTile(
          title: 'Created At',
          value: shift.createdAt.toString(),
        ),
        AppDetailTile(
          title: 'Updated At',
          value: shift.updatedAt?.toString() ?? '-',
        ),
      ],
    );

    // ===========================================================
    // DESKTOP
    // ===========================================================

    if (isDesktop) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: basicInformation,
              ),
              SizedBox(width: spacing),
              Expanded(
                child: shiftTiming,
              ),
            ],
          ),

          SizedBox(height: spacing),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: attendanceRules,
              ),
              SizedBox(width: spacing),
              Expanded(
                child: shiftType,
              ),
            ],
          ),

          SizedBox(height: spacing),

          auditInformation,
        ],
      );
    }

    // ===========================================================
    // TABLET
    // ===========================================================

    return Column(
      children: [
        basicInformation,

        SizedBox(height: spacing),

        shiftTiming,

        SizedBox(height: spacing),

        attendanceRules,

        SizedBox(height: spacing),

        shiftType,

        SizedBox(height: spacing),

        auditInformation,
      ],
    );
  }
}