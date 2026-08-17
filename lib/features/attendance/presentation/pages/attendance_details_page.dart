import 'package:flutter/material.dart';

import '../widgets/attendance_action_card.dart';
import '../../domain/entities/attendance_entity.dart';
import '../widgets/attendance_status_chip.dart';
import '../widgets/attendance_location_card.dart';
import '../widgets/attendance_timeline_card.dart';
import '../widgets/attendance_google_map.dart';
import '../widgets/open_map_button.dart';
import '../widgets/attendance_summary_card.dart';
import '../widgets/employee_info_card.dart';
import '../widgets/shift_info_card.dart';
import '../widgets/device_info_card.dart';
import '../widgets/company_info_card.dart';
import '../widgets/attendance_analytics_card.dart';
import '../widgets/employee_avatar_card.dart';
import '../widgets/attendance_basic_info_card.dart';
import '../widgets/attendance_remarks_card.dart';
import '../widgets/attendance_bottom_action_bar.dart';

class AttendanceDetailsPage extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceDetailsPage({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        title: const Text(
          'Attendance Details',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // =========================================================
            // RESPONSIVE CONTENT WIDTH
            // =========================================================
            //
            // Mobile  -> almost full width
            // Tablet  -> comfortable reading width
            // Desktop -> centered professional content width
            //
            final double horizontalPadding =
            constraints.maxWidth < 600
                ? 16
                : constraints.maxWidth < 1000
                ? 24
                : 32;

            final double maxContentWidth =
            constraints.maxWidth >= 1200
                ? 1100
                : constraints.maxWidth >= 900
                ? 900
                : double.infinity;

            return Scrollbar(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
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
                          // =================================================
                          // EMPLOYEE
                          // =================================================

                          EmployeeAvatarCard(
                            attendance: attendance,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // SUMMARY
                          // =================================================

                          AttendanceSummaryCard(
                            attendance: attendance,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // EMPLOYEE INFORMATION
                          // =================================================

                          EmployeeInfoCard(
                            attendance: attendance,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // SHIFT
                          // =================================================

                          ShiftInfoCard(
                            attendance: attendance,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // BASIC INFORMATION
                          // =================================================

                          AttendanceBasicInfoCard(
                            attendance: attendance,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // REMARKS
                          // =================================================

                          AttendanceRemarksCard(
                            remarks: attendance.remarks,
                          ),

                          const SizedBox(height: 20),

                          // =================================================
                          // CHECK IN LOCATION
                          // =================================================

                          AttendanceLocationCard(
                            title: 'Check In Location',
                            icon: Icons.login_rounded,
                            latitude:
                            attendance.checkInLatitude,
                            longitude:
                            attendance.checkInLongitude,
                            address:
                            attendance.checkInAddress,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // CHECK OUT LOCATION
                          // =================================================

                          AttendanceLocationCard(
                            title: 'Check Out Location',
                            icon: Icons.logout_rounded,
                            latitude:
                            attendance.checkOutLatitude,
                            longitude:
                            attendance.checkOutLongitude,
                            address:
                            attendance.checkOutAddress,
                          ),

                          const SizedBox(height: 20),

                          // =================================================
                          // DEVICE
                          // =================================================

                          DeviceInfoCard(
                            attendance: attendance,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // COMPANY
                          // =================================================

                          CompanyInfoCard(
                            attendance: attendance,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // TIMELINE
                          // =================================================

                          AttendanceTimelineCard(
                            checkInTime:
                            attendance.checkInTime,
                            checkOutTime:
                            attendance.checkOutTime,
                            workMinutes:
                            attendance.workMinutes,
                            overtimeMinutes:
                            attendance.overtimeMinutes,
                            lateMinutes:
                            attendance.lateMinutes,
                            earlyExitMinutes:
                            attendance.earlyExitMinutes,
                          ),

                          const SizedBox(height: 20),

                          // =================================================
                          // GOOGLE MAP
                          // =================================================

                          AttendanceGoogleMap(
                            latitude:
                            attendance.checkInLatitude,
                            longitude:
                            attendance.checkInLongitude,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // OPEN MAP
                          // =================================================

                          OpenMapButton(
                            latitude:
                            attendance.checkInLatitude,
                            longitude:
                            attendance.checkInLongitude,
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // ANALYTICS
                          // =================================================

                          AttendanceAnalyticsCard(
                            attendance: attendance,
                          ),

                          const SizedBox(height: 24),

                          // =================================================
                          // BOTTOM ACTION BAR
                          // =================================================

                          AttendanceBottomActionBar(
                            onBack: () =>
                                Navigator.pop(context),
                            onEdit: () {
                              // TODO
                            },
                          ),

                          const SizedBox(height: 24),

                          // =================================================
                          // ACTION CARD
                          // =================================================

                          AttendanceActionCard(
                            onShare: () {},
                            onPdf: () {},
                            onPrint: () {},
                            onEdit: () {},
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}