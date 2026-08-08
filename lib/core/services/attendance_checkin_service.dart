import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/attendance/data/models/attendance_model.dart';
import '../../features/attendance/data/repositories/attendance_repository.dart';
import '../../features/attendance/domain/entities/attendance_entity.dart';
import 'location_service.dart';

class AttendanceCheckInService {
  AttendanceCheckInService();

  final SupabaseClient _client = Supabase.instance.client;

  final AttendanceRepository _repository =
  AttendanceRepository();

  final LocationService _locationService =
  const LocationService();

  //==========================================================
  // CHECK IN
  //==========================================================

  Future<bool> checkIn({
    required AttendanceEntity attendance,
  }) async {
    // -------------------------------------------------------
    // Employee ID check
    // -------------------------------------------------------

    if (attendance.employeeId == null ||
        attendance.employeeId!.isEmpty) {
      throw Exception(
        'Employee ID is required.',
      );
    }

    // -------------------------------------------------------
    // Today's date
    // -------------------------------------------------------

    final today = DateTime.now();

    final todayDate = today
        .toIso8601String()
        .split('T')
        .first;

    // -------------------------------------------------------
    // Check today's attendance
    //
    // Same employee + same date = only one attendance
    // -------------------------------------------------------

    final existing = await _client
        .from('attendance')
        .select('id')
        .eq(
      'employee_id',
      attendance.employeeId!,
    )
        .eq(
      'attendance_date',
      todayDate,
    )
        .maybeSingle();

    if (existing != null) {
      throw Exception(
        'Already checked in today.',
      );
    }

    // -------------------------------------------------------
    // Get current location
    // -------------------------------------------------------

    final location =
    await _locationService.getLocation();

    // -------------------------------------------------------
    // Get device name
    // -------------------------------------------------------

    final deviceName =
    await _getDeviceName();

    // -------------------------------------------------------
    // Create new attendance entity
    //
    // Important:
    // id is NOT generated here.
    // Supabase database will generate UUID.
    // -------------------------------------------------------

    final attendanceWithDevice =
    attendance.copyWith(
      checkInTime: DateTime.now(),

      checkInLatitude:
      location.latitude,

      checkInLongitude:
      location.longitude,

      deviceName: deviceName,
    );

    // -------------------------------------------------------
    // Entity -> Model
    //
    // Repository expects AttendanceModel.
    // -------------------------------------------------------

    final model =
    AttendanceModel.fromEntity(
      attendanceWithDevice,
    );

    // -------------------------------------------------------
    // INSERT
    //
    // toInsertMap() must NOT contain id.
    // Database generates id automatically.
    // -------------------------------------------------------

    await _repository.insert(model);

    return true;
  }

  //==========================================================
  // CHECK OUT
  Future<bool> checkOut({
    required String employeeId,
  }) async {
    if (employeeId.isEmpty) {
      throw Exception(
        'Employee ID is required.',
      );
    }

    // =======================================================
    // CURRENT DATE
    // =======================================================

    final now = DateTime.now();

    final todayDate =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    debugPrint('========================================');
    debugPrint('              CHECK OUT');
    debugPrint('========================================');
    debugPrint('Employee ID => $employeeId');
    debugPrint('Today Date  => $todayDate');

    // =======================================================
    // SUPABASE AUTH DEBUG
    // =======================================================

    final session = _client.auth.currentSession;
    final user = _client.auth.currentUser;

    debugPrint('========================================');
    debugPrint('          SUPABASE AUTH DEBUG');
    debugPrint('========================================');
    debugPrint(
      'Session => ${session != null}',
    );
    debugPrint(
      'User ID => ${user?.id}',
    );
    debugPrint(
      'Email => ${user?.email}',
    );
    debugPrint('========================================');

    // =======================================================
    // FIND TODAY'S ATTENDANCE
    // =======================================================

    final response = await _client
        .from('attendance')
        .select()
        .eq(
      'employee_id',
      employeeId,
    )
        .eq(
      'attendance_date',
      todayDate,
    )
        .order(
      'created_at',
      ascending: false,
    )
        .limit(1);

    // =======================================================
    // QUERY DEBUG
    // =======================================================

    debugPrint('========================================');
    debugPrint('          ATTENDANCE QUERY');
    debugPrint('========================================');
    debugPrint(
      'Employee ID => $employeeId',
    );
    debugPrint(
      'Attendance Date => $todayDate',
    );
    debugPrint(
      'Rows => ${response.length}',
    );
    debugPrint(
      'Data => $response',
    );
    debugPrint('========================================');

    // =======================================================
    // ATTENDANCE NOT FOUND
    // =======================================================

    if (response.isEmpty) {
      debugPrint(
        'ERROR => Today attendance not found.',
      );

      throw Exception(
        'Today attendance not found.',
      );
    }

    // =======================================================
    // GET ATTENDANCE
    // =======================================================

    final attendance = response.first;

    final attendanceId =
    attendance['id'] as String?;

    final attendanceDate =
    attendance['attendance_date'];

    final checkInTime =
    attendance['check_in_time'];

    final checkOutTime =
    attendance['check_out_time'];

    debugPrint('========================================');
    debugPrint('        TODAY ATTENDANCE');
    debugPrint('========================================');
    debugPrint(
      'Attendance ID => $attendanceId',
    );
    debugPrint(
      'Employee ID => ${attendance['employee_id']}',
    );
    debugPrint(
      'Attendance Date => $attendanceDate',
    );
    debugPrint(
      'Check In => $checkInTime',
    );
    debugPrint(
      'Check Out => $checkOutTime',
    );
    debugPrint('========================================');

    // =======================================================
    // INVALID ATTENDANCE ID
    // =======================================================

    if (attendanceId == null ||
        attendanceId.isEmpty) {
      throw Exception(
        'Attendance ID not found.',
      );
    }

    // =======================================================
    // ALREADY CHECKED OUT
    // =======================================================

    if (checkOutTime != null) {
      debugPrint(
        'ERROR => Already checked out.',
      );

      throw Exception(
        'Already checked out.',
      );
    }

    // =======================================================
    // GET CURRENT LOCATION
    // =======================================================

    debugPrint(
      'Getting current location...',
    );

    final location =
    await _locationService.getLocation();

    debugPrint(
      'Checkout Latitude => ${location.latitude}',
    );

    debugPrint(
      'Checkout Longitude => ${location.longitude}',
    );

    // =======================================================
    // UPDATE EXISTING ATTENDANCE
    // =======================================================

    debugPrint(
      'Updating attendance...',
    );

    await _repository.checkOut(
      attendanceId: attendanceId,
      checkOutTime: now,
      latitude: location.latitude,
      longitude: location.longitude,
    );

    // =======================================================
    // SUCCESS
    // =======================================================

    debugPrint('========================================');
    debugPrint('        CHECK OUT SUCCESS');
    debugPrint('========================================');
    debugPrint(
      'Attendance ID => $attendanceId',
    );
    debugPrint(
      'Employee ID => $employeeId',
    );
    debugPrint(
      'Checkout Time => $now',
    );
    debugPrint('========================================');

    return true;
  }

  //==========================================================
  // GET DEVICE NAME
  //==========================================================

  Future<String> _getDeviceName() async {
    final deviceInfo =
    DeviceInfoPlugin();

    // -------------------------------------------------------
    // ANDROID
    // -------------------------------------------------------

    if (defaultTargetPlatform ==
        TargetPlatform.android) {
      final info =
      await deviceInfo.androidInfo;

      return '${info.manufacturer} ${info.model}';
    }

    // -------------------------------------------------------
    // IOS
    // -------------------------------------------------------

    if (defaultTargetPlatform ==
        TargetPlatform.iOS) {
      final info =
      await deviceInfo.iosInfo;

      return info.name;
    }

    // -------------------------------------------------------
    // OTHER PLATFORM
    // -------------------------------------------------------

    return 'Unknown Device';
  }
}