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
  // BOOLEAN
  // =============================================================

  String _yesNo(bool value) {
    return value ? 'Yes' : 'No';
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

      // ===========================================================
      // APP BAR
      // ===========================================================

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

      // ===========================================================
      // BODY
      // ===========================================================

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
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
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
                                    colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  shift.name.isEmpty
                                      ? '-'
                                      : shift.name,
                                  textAlign: TextAlign.center,
                                  style: theme
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  shift.code.isEmpty
                                      ? '-'
                                      : shift.code,
                                  textAlign: TextAlign.center,
                                  style: theme
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                    fontWeight:
                                    FontWeight.w600,
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
                        // RESPONSIVE CONTENT
                        // =========================================

                        if (isDesktop || isTablet)
                          _buildResponsiveSections(
                            context,
                            isDesktop: isDesktop,
                          )
                        else ...[
                          _buildMobileSections(context),
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
  // MOBILE SECTIONS
  // =============================================================

  Widget _buildMobileSections(BuildContext context) {
    return Column(
      children: [
        // =========================================================
        // BASIC INFORMATION
        // =========================================================

        _buildBasicInformation(context),

        const SizedBox(height: 16),

        // =========================================================
        // SHIFT TIMING
        // =========================================================

        _buildShiftTiming(context),

        const SizedBox(height: 16),

        // =========================================================
        // ATTENDANCE RULES
        // =========================================================

        _buildAttendanceRules(context),

        const SizedBox(height: 16),

        // =========================================================
        // WORKING HOURS
        // =========================================================

        _buildWorkingHours(context),

        const SizedBox(height: 16),

        // =========================================================
        // SHIFT OPTIONS
        // =========================================================

        _buildShiftOptions(context),

        const SizedBox(height: 16),

        // =========================================================
        // CHECK IN / CHECK OUT
        // =========================================================

        _buildAttendanceRequirements(context),

        const SizedBox(height: 16),

        // =========================================================
        // AUDIT INFORMATION
        // =========================================================

        _buildAuditInformation(context),
      ],
    );
  }

  // =============================================================
  // BASIC INFORMATION
  // =============================================================

  Widget _buildBasicInformation(BuildContext context) {
    return _buildDetailSection(
      context: context,
      title: 'Basic Information',
      icon: Icons.info_outline_rounded,
      children: [
        AppDetailTile(
          title: 'Company ID',
          value: shift.companyId,
        ),

        AppDetailTile(
          title: 'Shift Code',
          value: shift.code.isEmpty ? '-' : shift.code,
        ),

        AppDetailTile(
          title: 'Shift Name',
          value: shift.name.isEmpty ? '-' : shift.name,
        ),

        AppDetailTile(
          title: 'Description',
          value: shift.description.isEmpty
              ? '-'
              : shift.description,
        ),
      ],
    );
  }

  // =============================================================
  // SHIFT TIMING
  // =============================================================

  Widget _buildShiftTiming(BuildContext context) {
    return _buildDetailSection(
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
      ],
    );
  }

  // =============================================================
  // ATTENDANCE RULES
  // =============================================================

  Widget _buildAttendanceRules(BuildContext context) {
    return _buildDetailSection(
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
          title: 'Late Grace',
          value: '${shift.lateGraceMinutes} Minutes',
        ),

        AppDetailTile(
          title: 'Early Leave Grace',
          value:
          '${shift.earlyLeaveGraceMinutes} Minutes',
        ),

        AppDetailTile(
          title: 'Half Day After',
          value:
          '${shift.halfDayAfterMinutes} Minutes',
        ),
      ],
    );
  }

  // =============================================================
  // WORKING HOURS
  // =============================================================

  Widget _buildWorkingHours(BuildContext context) {
    return _buildDetailSection(
      context: context,
      title: 'Working Hours',
      icon: Icons.hourglass_bottom_rounded,
      children: [
        AppDetailTile(
          title: 'Minimum Working Hours',
          value:
          '${shift.minimumWorkingHours.toStringAsFixed(2)} Hours',
        ),

        AppDetailTile(
          title: 'Half Day Threshold',
          value:
          '${shift.halfDayThresholdHours.toStringAsFixed(2)} Hours',
        ),
      ],
    );
  }

  // =============================================================
  // SHIFT OPTIONS
  // =============================================================

  Widget _buildShiftOptions(BuildContext context) {
    return _buildDetailSection(
      context: context,
      title: 'Shift Options',
      icon: Icons.settings_outlined,
      children: [
        AppDetailTile(
          title: 'Night Shift',
          value: _yesNo(shift.isNightShift),
        ),

        AppDetailTile(
          title: 'Flexible Shift',
          value: _yesNo(shift.isFlexible),
        ),

        AppDetailTile(
          title: 'Status',
          value: shift.isActive
              ? 'Active'
              : 'Inactive',
        ),
      ],
    );
  }

  // =============================================================
  // ATTENDANCE REQUIREMENTS
  // =============================================================

  Widget _buildAttendanceRequirements(
      BuildContext context) {
    return _buildDetailSection(
      context: context,
      title: 'Attendance Requirements',
      icon: Icons.fact_check_rounded,
      children: [
        AppDetailTile(
          title: 'Check In Required',
          value: _yesNo(shift.checkInRequired),
        ),

        AppDetailTile(
          title: 'Check Out Required',
          value: _yesNo(shift.checkOutRequired),
        ),
      ],
    );
  }

  // =============================================================
  // AUDIT INFORMATION
  // =============================================================

  Widget _buildAuditInformation(BuildContext context) {
    return _buildDetailSection(
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

        AppDetailTile(
          title: 'Created By',
          value:
          shift.createdBy?.isEmpty ?? true
              ? '-'
              : shift.createdBy!,
        ),

        AppDetailTile(
          title: 'Updated By',
          value:
          shift.updatedBy?.isEmpty ?? true
              ? '-'
              : shift.updatedBy!,
        ),
      ],
    );
  }

  // =============================================================
  // RESPONSIVE SECTIONS
  // =============================================================

  Widget _buildResponsiveSections(
      BuildContext context, {
        required bool isDesktop,
      }) {
    const double spacing = 16;

    final basicInformation =
    _buildBasicInformation(context);

    final shiftTiming =
    _buildShiftTiming(context);

    final attendanceRules =
    _buildAttendanceRules(context);

    final workingHours =
    _buildWorkingHours(context);

    final shiftOptions =
    _buildShiftOptions(context);

    final attendanceRequirements =
    _buildAttendanceRequirements(context);

    final auditInformation =
    _buildAuditInformation(context);

    // ===========================================================
    // DESKTOP
    // ===========================================================

    if (isDesktop) {
      return Column(
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: basicInformation,
              ),
              const SizedBox(width: spacing),
              Expanded(
                child: shiftTiming,
              ),
            ],
          ),

          const SizedBox(height: spacing),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: attendanceRules,
              ),
              const SizedBox(width: spacing),
              Expanded(
                child: workingHours,
              ),
            ],
          ),

          const SizedBox(height: spacing),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Expanded(
                child: shiftOptions,
              ),
              const SizedBox(width: spacing),
              Expanded(
                child: attendanceRequirements,
              ),
            ],
          ),

          const SizedBox(height: spacing),

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

        const SizedBox(height: spacing),

        shiftTiming,

        const SizedBox(height: spacing),

        attendanceRules,

        const SizedBox(height: spacing),

        workingHours,

        const SizedBox(height: spacing),

        shiftOptions,

        const SizedBox(height: spacing),

        attendanceRequirements,

        const SizedBox(height: spacing),

        auditInformation,
      ],
    );
  }
}