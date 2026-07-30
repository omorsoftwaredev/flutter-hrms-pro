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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Details"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EmployeeAvatarCard(
              attendance: attendance,
            ),
        
            const SizedBox(height: 16),
            AttendanceSummaryCard(
              attendance: attendance,
            ),
        
            const SizedBox(height: 16),
        
            EmployeeInfoCard(
              attendance: attendance,
            ),
        
            const SizedBox(height: 16),
            ShiftInfoCard(
              attendance: attendance,
            ),
        
            const SizedBox(height: 16),
            AttendanceBasicInfoCard(
              attendance: attendance,
            ),
        
            const SizedBox(height: 16),
        
            AttendanceRemarksCard(
              remarks: attendance.remarks,
            ),
        
            const SizedBox(height: 20),
        
            AttendanceLocationCard(
              title: "Check In Location",
              icon: Icons.login,
              latitude: attendance.checkInLatitude,
              longitude: attendance.checkInLongitude,
              address: attendance.checkInAddress,
            ),
        
            const SizedBox(height: 16),
        
            AttendanceLocationCard(
              title: "Check Out Location",
              icon: Icons.logout,
              latitude: attendance.checkOutLatitude,
              longitude: attendance.checkOutLongitude,
              address: attendance.checkOutAddress,
            ),
            const SizedBox(height: 20),
            DeviceInfoCard(
              attendance: attendance,
            ),
        
            const SizedBox(height: 16),
            CompanyInfoCard(
              attendance: attendance,
            ),
        
            const SizedBox(height: 16),
        
            AttendanceTimelineCard(
              checkInTime: attendance.checkInTime,
              checkOutTime: attendance.checkOutTime,
              workMinutes: attendance.workMinutes,
              overtimeMinutes: attendance.overtimeMinutes,
              lateMinutes: attendance.lateMinutes,
              earlyExitMinutes: attendance.earlyExitMinutes,
            ),
            const SizedBox(height: 20),
        
            AttendanceGoogleMap(
              latitude: attendance.checkInLatitude,
              longitude: attendance.checkInLongitude,
            ),
            const SizedBox(height: 16),
        
            OpenMapButton(
              latitude: attendance.checkInLatitude,
              longitude: attendance.checkInLongitude,
            ),
            const SizedBox(height: 16),
            AttendanceAnalyticsCard(
              attendance: attendance,
            ),
        
            const SizedBox(height: 24),
        
            AttendanceBottomActionBar(
              onBack: () => Navigator.pop(context),
              onEdit: () {
                // TODO
              },
            ),
            const SizedBox(height: 24),
            AttendanceActionCard(
              onShare: () {},
        
              onPdf: () {},
        
              onPrint: () {},
        
              onEdit: () {},
            ),
          ],
        ),
      ),
    );
  }
}