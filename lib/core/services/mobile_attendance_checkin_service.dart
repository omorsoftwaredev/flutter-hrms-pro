import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/attendance/mobile_attendance/data/models/mobile_attendance_model.dart';
import '../../features/attendance/mobile_attendance/data/repositories/mobile_attendance_repository.dart';
import '../../features/attendance/mobile_attendance/domain/entities/mobile_attendance_entity.dart';
import '../../utils/DeviceInfoService.dart';
import 'location_service.dart';

class MobileAttendanceCheckInService {
  MobileAttendanceCheckInService();

  final SupabaseClient _client = Supabase.instance.client;

  final MobileAttendanceRepository _repository =
  MobileAttendanceRepository();

  final LocationService _locationService =
  const LocationService();

  // ==============================================================
  // CHECK IN
  // ==============================================================

  Future<bool> checkIn({
    required MobileAttendanceEntity attendance,
  }) async {
    // ------------------------------------------------------------
    // EMPLOYEE ID VALIDATION
    // ------------------------------------------------------------

    final employeeId = attendance.employeeId?.trim();

    if (employeeId == null || employeeId.isEmpty) {
      throw Exception('Employee ID is required.');
    }

    // ------------------------------------------------------------
    // TODAY
    // ------------------------------------------------------------

    final now = DateTime.now();

    final todayDate =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    // ------------------------------------------------------------
    // CHECK EXISTING ATTENDANCE
    //
    // Database also has:
    // UNIQUE(employee_id, attendance_date)
    //
    // So this is UI/business-level protection.
    // Database remains final protection.
    // ------------------------------------------------------------

    final existing = await _client
        .from('attendance')
        .select('id')
        .eq('employee_id', employeeId)
        .eq('attendance_date', todayDate)
        .maybeSingle();

    if (existing != null) {
      throw Exception(
        'You have already checked in today.',
      );
    }

    // ------------------------------------------------------------
    // CURRENT LOCATION
    // ------------------------------------------------------------

    final location =
    await _locationService.getLocation();

    // ------------------------------------------------------------
    // DEVICE
    // ------------------------------------------------------------

    final deviceName =
    await _getDeviceName();
    final String? deviceId =
    await DeviceInfoService.instance.getDeviceId();

    print('DEVICE ID: $deviceId');
    // ------------------------------------------------------------
    // CREATE CHECK-IN ENTITY
    //
    // Important:
    // - id is NOT generated here.
    // - Supabase generates UUID.
    // - Address and accuracy are preserved.
    // ------------------------------------------------------------

    final attendanceWithDevice =
    attendance.copyWith(
      checkInTime: now,

      checkInLatitude:
      location.latitude,

      checkInLongitude:
      location.longitude,

      checkInAddress:
      location.address,

      checkInAccuracy:
      location.accuracy,

      deviceName: deviceName,
      deviceId: deviceId
    );

    // ------------------------------------------------------------
    // ENTITY -> MODEL
    // ------------------------------------------------------------

    final model =
    MobileAttendanceModel.fromEntity(
      attendanceWithDevice,
    );

    // ------------------------------------------------------------
    // INSERT
    // ------------------------------------------------------------

    await _repository.insert(model);

    return true;
  }

  // ==============================================================
  // CHECK OUT
  // ==============================================================

  Future<bool> checkOut({
    required String employeeId,
  }) async {
    final employee = employeeId.trim();

    if (employee.isEmpty) {
      throw Exception(
        'Employee ID is required.',
      );
    }

    // ------------------------------------------------------------
    // CURRENT DATE
    // ------------------------------------------------------------

    final now = DateTime.now();

    final todayDate =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    // ------------------------------------------------------------
    // FIND TODAY'S ATTENDANCE
    // ------------------------------------------------------------

    final response = await _client
        .from('attendance')
        .select()
        .eq('employee_id', employee)
        .eq('attendance_date', todayDate)
        .order(
      'created_at',
      ascending: false,
    )
        .limit(1);

    // ------------------------------------------------------------
    // ATTENDANCE NOT FOUND
    // ------------------------------------------------------------

    if (response.isEmpty) {
      throw Exception(
        'Today attendance not found.',
      );
    }

    // ------------------------------------------------------------
    // GET ATTENDANCE
    // ------------------------------------------------------------

    final attendance =
        response.first;

    final attendanceId =
    attendance['id']?.toString();

    if (attendanceId == null ||
        attendanceId.isEmpty) {
      throw Exception(
        'Attendance ID not found.',
      );
    }

    // ------------------------------------------------------------
    // CHECK-IN VALIDATION
    // ------------------------------------------------------------

    final checkInValue =
    attendance['check_in_time'];

    if (checkInValue == null) {
      throw Exception(
        'Check-in time not found.',
      );
    }

    // ------------------------------------------------------------
    // ALREADY CHECKED OUT
    // ------------------------------------------------------------

    final checkOutValue =
    attendance['check_out_time'];

    if (checkOutValue != null) {
      throw Exception(
        'You have already checked out today.',
      );
    }

    // ------------------------------------------------------------
    // CURRENT LOCATION
    // ------------------------------------------------------------

    final location =
    await _locationService.getLocation();

    // ------------------------------------------------------------
    // CHECK-IN TIME
    // ------------------------------------------------------------

    final checkInTime =
    DateTime.tryParse(
      checkInValue.toString(),
    );

    if (checkInTime == null) {
      throw Exception(
        'Invalid check-in time.',
      );
    }

    // ------------------------------------------------------------
    // WORK MINUTES
    //
    // Calculate actual worked duration.
    // This will be stored in database.
    // ------------------------------------------------------------

    final workMinutes =
        now.difference(checkInTime).inMinutes;

    final safeWorkMinutes =
    workMinutes < 0
        ? 0
        : workMinutes;

    // ------------------------------------------------------------
    // OVERTIME
    //
    // For now we calculate overtime after 8 hours.
    //
    // Later we can make this shift-based:
    // Shift Start -> Shift End -> Grace -> Overtime
    // ------------------------------------------------------------

    const standardWorkMinutes = 8 * 60;

    final overtimeMinutes =
    safeWorkMinutes >
        standardWorkMinutes
        ? safeWorkMinutes -
        standardWorkMinutes
        : 0;

    // ------------------------------------------------------------
    // UPDATE ATTENDANCE
    // ------------------------------------------------------------

    await _client
        .from('attendance')
        .update({
      'check_out_time':
      now.toIso8601String(),

      'check_out_latitude':
      location.latitude,

      'check_out_longitude':
      location.longitude,

      'check_out_address':
      location.address,

      'check_out_accuracy':
      location.accuracy,

      'updated_at':
      now.toIso8601String(),
    }).eq(
      'id',
      attendanceId,
    );

    return true;
  }

  // ==============================================================
  // GET DEVICE NAME
  // ==============================================================

  Future<String> _getDeviceName() async {
    final deviceInfo =
    DeviceInfoPlugin();

    // ------------------------------------------------------------
    // ANDROID
    // ------------------------------------------------------------

    if (defaultTargetPlatform ==
        TargetPlatform.android) {
      final info =
      await deviceInfo.androidInfo;

      final manufacturer =
      info.manufacturer.trim();

      final model =
      info.model.trim();

      if (manufacturer.isEmpty &&
          model.isEmpty) {
        return 'Android Device';
      }

      if (manufacturer.isEmpty) {
        return model;
      }

      if (model.isEmpty) {
        return manufacturer;
      }

      return '$manufacturer $model';
    }

    // ------------------------------------------------------------
    // IOS
    // ------------------------------------------------------------

    if (defaultTargetPlatform ==
        TargetPlatform.iOS) {
      final info =
      await deviceInfo.iosInfo;

      final name =
      info.name.trim();

      if (name.isNotEmpty) {
        return name;
      }

      return 'iOS Device';
    }

    // ------------------------------------------------------------
    // OTHER PLATFORM
    // ------------------------------------------------------------

    return 'Unknown Device';
  }
}