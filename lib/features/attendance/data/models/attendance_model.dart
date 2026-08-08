import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    super.id,
    super.companyId,
    super.employeeId,
    super.departmentId,
    super.designationId,
    super.shiftId,
    super.holidayId,
    super.leaveRequestId,

    required super.attendanceNo,
    required super.attendanceDate,

    super.shiftName,
    super.shiftStart,
    super.shiftEnd,

    super.checkInTime,
    super.checkOutTime,

    super.workMinutes,
    super.overtimeMinutes,
    super.lateMinutes,
    super.earlyExitMinutes,

    super.attendanceStatus,

    super.isLeave,
    super.isHoliday,
    super.isWeekend,

    super.checkInLatitude,
    super.checkInLongitude,
    super.checkOutLatitude,
    super.checkOutLongitude,

    super.deviceName,
    super.deviceId,
    super.ipAddress,

    super.remarks,

    super.isActive,

    super.createdBy,
    super.updatedBy,

    super.createdAt,
    super.updatedAt,

    super.checkInAddress,
    super.checkOutAddress,
  });

  // ============================================================
  // FROM MAP
  // ============================================================

  factory AttendanceModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return AttendanceModel(
      id: map['id']?.toString(),

      companyId: map['company_id']?.toString(),
      employeeId: map['employee_id']?.toString(),
      departmentId: map['department_id']?.toString(),
      designationId: map['designation_id']?.toString(),
      shiftId: map['shift_id']?.toString(),
      holidayId: map['holiday_id']?.toString(),
      leaveRequestId: map['leave_request_id']?.toString(),

      attendanceNo:
      map['attendance_no']?.toString() ?? '',

      attendanceDate:
      DateTime.parse(
        map['attendance_date'].toString(),
      ),

      shiftName:
      map['shift_name']?.toString(),

      shiftStart:
      map['shift_start']?.toString(),

      shiftEnd:
      map['shift_end']?.toString(),

      checkInTime:
      map['check_in_time'] != null
          ? DateTime.parse(
        map['check_in_time'].toString(),
      )
          : null,

      checkOutTime:
      map['check_out_time'] != null
          ? DateTime.parse(
        map['check_out_time'].toString(),
      )
          : null,

      workMinutes:
      (map['work_minutes'] as num?)?.toInt() ?? 0,

      overtimeMinutes:
      (map['overtime_minutes'] as num?)?.toInt() ?? 0,

      lateMinutes:
      (map['late_minutes'] as num?)?.toInt() ?? 0,

      earlyExitMinutes:
      (map['early_exit_minutes'] as num?)?.toInt() ?? 0,

      attendanceStatus:
      map['attendance_status']?.toString() ??
          'PRESENT',

      isLeave:
      map['is_leave'] as bool? ?? false,

      isHoliday:
      map['is_holiday'] as bool? ?? false,

      isWeekend:
      map['is_weekend'] as bool? ?? false,

      checkInLatitude:
      (map['check_in_latitude'] as num?)
          ?.toDouble(),

      checkInLongitude:
      (map['check_in_longitude'] as num?)
          ?.toDouble(),

      checkOutLatitude:
      (map['check_out_latitude'] as num?)
          ?.toDouble(),

      checkOutLongitude:
      (map['check_out_longitude'] as num?)
          ?.toDouble(),

      deviceName:
      map['device_name']?.toString(),

      deviceId:
      map['device_id']?.toString(),

      ipAddress:
      map['ip_address']?.toString(),

      remarks:
      map['remarks']?.toString(),

      isActive:
      map['is_active'] as bool? ?? true,

      createdBy:
      map['created_by']?.toString(),

      updatedBy:
      map['updated_by']?.toString(),

      createdAt:
      map['created_at'] != null
          ? DateTime.parse(
        map['created_at'].toString(),
      )
          : null,

      updatedAt:
      map['updated_at'] != null
          ? DateTime.parse(
        map['updated_at'].toString(),
      )
          : null,

      checkInAddress:
      map['check_in_address']?.toString(),

      checkOutAddress:
      map['check_out_address']?.toString(),
    );
  }

  // ============================================================
  // FROM ENTITY
  // ============================================================

  factory AttendanceModel.fromEntity(
      AttendanceEntity entity,
      ) {
    return AttendanceModel(
      id: entity.id,

      companyId: entity.companyId,
      employeeId: entity.employeeId,
      departmentId: entity.departmentId,
      designationId: entity.designationId,
      shiftId: entity.shiftId,
      holidayId: entity.holidayId,
      leaveRequestId: entity.leaveRequestId,

      attendanceNo: entity.attendanceNo,
      attendanceDate: entity.attendanceDate,

      shiftName: entity.shiftName,
      shiftStart: entity.shiftStart,
      shiftEnd: entity.shiftEnd,

      checkInTime: entity.checkInTime,
      checkOutTime: entity.checkOutTime,

      workMinutes: entity.workMinutes,
      overtimeMinutes: entity.overtimeMinutes,
      lateMinutes: entity.lateMinutes,
      earlyExitMinutes: entity.earlyExitMinutes,

      attendanceStatus:
      entity.attendanceStatus,

      isLeave: entity.isLeave,
      isHoliday: entity.isHoliday,
      isWeekend: entity.isWeekend,

      checkInLatitude:
      entity.checkInLatitude,

      checkInLongitude:
      entity.checkInLongitude,

      checkOutLatitude:
      entity.checkOutLatitude,

      checkOutLongitude:
      entity.checkOutLongitude,

      deviceName:
      entity.deviceName,

      deviceId:
      entity.deviceId,

      ipAddress:
      entity.ipAddress,

      remarks:
      entity.remarks,

      isActive:
      entity.isActive,

      createdBy:
      entity.createdBy,

      updatedBy:
      entity.updatedBy,

      createdAt:
      entity.createdAt,

      updatedAt:
      entity.updatedAt,

      checkInAddress:
      entity.checkInAddress,

      checkOutAddress:
      entity.checkOutAddress,
    );
  }

  // ============================================================
  // INSERT MAP
  //
  // IMPORTANT:
  // id এখানে নেই।
  //
  // Database নিজে:
  // gen_random_uuid()
  // দিয়ে id তৈরি করবে।
  // ============================================================

  Map<String, dynamic> toInsertMap() {
    return {
      'company_id': companyId,
      'employee_id': employeeId,
      'department_id': departmentId,
      'designation_id': designationId,
      'shift_id': shiftId,
      'holiday_id': holidayId,
      'leave_request_id': leaveRequestId,

      'attendance_no': attendanceNo,

      'attendance_date':
      attendanceDate
          .toIso8601String()
          .split('T')
          .first,

      'shift_name': shiftName,
      'shift_start': shiftStart,
      'shift_end': shiftEnd,

      'check_in_time':
      checkInTime?.toIso8601String(),

      'check_out_time':
      checkOutTime?.toIso8601String(),

      'work_minutes': workMinutes,
      'overtime_minutes': overtimeMinutes,
      'late_minutes': lateMinutes,
      'early_exit_minutes': earlyExitMinutes,

      'attendance_status':
      attendanceStatus,

      'is_leave': isLeave,
      'is_holiday': isHoliday,
      'is_weekend': isWeekend,

      'check_in_latitude':
      checkInLatitude,

      'check_in_longitude':
      checkInLongitude,

      'check_out_latitude':
      checkOutLatitude,

      'check_out_longitude':
      checkOutLongitude,

      'device_name': deviceName,
      'device_id': deviceId,
      'ip_address': ipAddress,

      'remarks': remarks,

      'is_active': isActive,

      'created_by': createdBy,
      'updated_by': updatedBy,

      'check_in_address':
      checkInAddress,

      'check_out_address':
      checkOutAddress,
    };
  }

  // ============================================================
  // UPDATE MAP
  //
  // এখানে id পাঠানোর দরকার নেই।
  // Repository WHERE id = attendance.id দিয়ে update করবে।
  //
  // created_at-ও update করছি না।
  // ============================================================

  Map<String, dynamic> toUpdateMap() {
    return {
      'company_id': companyId,
      'employee_id': employeeId,
      'department_id': departmentId,
      'designation_id': designationId,
      'shift_id': shiftId,
      'holiday_id': holidayId,
      'leave_request_id': leaveRequestId,

      'attendance_no': attendanceNo,

      'attendance_date':
      attendanceDate
          .toIso8601String()
          .split('T')
          .first,

      'shift_name': shiftName,
      'shift_start': shiftStart,
      'shift_end': shiftEnd,

      'check_in_time':
      checkInTime?.toIso8601String(),

      'check_out_time':
      checkOutTime?.toIso8601String(),

      'work_minutes': workMinutes,
      'overtime_minutes': overtimeMinutes,
      'late_minutes': lateMinutes,
      'early_exit_minutes': earlyExitMinutes,

      'attendance_status':
      attendanceStatus,

      'is_leave': isLeave,
      'is_holiday': isHoliday,
      'is_weekend': isWeekend,

      'check_in_latitude':
      checkInLatitude,

      'check_in_longitude':
      checkInLongitude,

      'check_out_latitude':
      checkOutLatitude,

      'check_out_longitude':
      checkOutLongitude,

      'device_name': deviceName,
      'device_id': deviceId,
      'ip_address': ipAddress,

      'remarks': remarks,

      'is_active': isActive,

      'updated_by': updatedBy,

      'updated_at':
      DateTime.now().toIso8601String(),

      'check_in_address':
      checkInAddress,

      'check_out_address':
      checkOutAddress,
    };
  }
}