import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/attendance/data/repositories/attendance_repository.dart';
import '../../features/attendance/domain/entities/attendance_entity.dart';
import 'location_service.dart';

class AttendanceCheckInService {
  AttendanceCheckInService();

  final _client = Supabase.instance.client;

  final LocationService _locationService =
  const LocationService();

  ///=========================================
  /// CHECK IN
  ///=========================================
  Future<bool> checkIn({
    required AttendanceEntity attendance,
  }) async {
    final today = DateTime.now();

    final todayAttendance =
    await Supabase.instance.client
        .from('attendance')
        .select('id')
        .eq('employee_id', attendance.employeeId!)
        .eq(
      'attendance_date',
      today.toIso8601String().split('T').first,
    )
        .maybeSingle();

    if (todayAttendance != null) {
      throw Exception(
        'Already checked in today.',
      );
    }

    await AttendanceRepository().insert(
      attendance,
    );

    return true;
  }

  ///=========================================
  /// CHECK OUT
  ///=========================================
  Future<bool> checkOut({
    required String employeeId,
  }) async {
    final today = DateTime.now();

    final attendance =
    await Supabase.instance.client
        .from('attendance')
        .select()
        .eq('employee_id', employeeId)
        .eq(
      'attendance_date',
      today.toIso8601String().split('T').first,
    )
        .maybeSingle();

    if (attendance == null) {
      throw Exception(
        'Today attendance not found.',
      );
    }

    if (attendance['check_out_time'] != null) {
      throw Exception(
        'Already checked out.',
      );
    }

    final location =
    await const LocationService()
        .getLocation();

    await AttendanceRepository().checkOut(
      attendanceId: attendance['id'],
      checkOutTime: DateTime.now(),
      latitude: location.latitude,
      longitude: location.longitude,
    );

    return true;
  }

  ///=========================================
  /// DEVICE NAME
  ///=========================================

  Future<String> _getDeviceName() async {
    final device =
    DeviceInfoPlugin();

    if (defaultTargetPlatform ==
        TargetPlatform.android) {
      final info =
      await device.androidInfo;

      return
        "${info.manufacturer} ${info.model}";
    }

    if (defaultTargetPlatform ==
        TargetPlatform.iOS) {
      final info =
      await device.iosInfo;

      return info.name;
    }

    return "Unknown Device";
  }
}