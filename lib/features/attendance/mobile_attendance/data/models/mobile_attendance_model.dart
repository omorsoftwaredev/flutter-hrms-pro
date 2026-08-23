import '../../domain/entities/mobile_attendance_entity.dart';

class MobileAttendanceModel extends MobileAttendanceEntity {
  //=================================================================
  // CONSTRUCTOR
  //=================================================================

  const MobileAttendanceModel({
    super.id,
    super.companyId,
    super.employeeId,
    super.departmentId,
    super.designationId,
    super.shiftId,
    required super.attendanceNo,
    required super.attendanceDate,
    super.checkInTime,
    super.checkOutTime,
    super.attendanceStatus,
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
    super.checkInAccuracy,
    super.checkOutAccuracy,
  });

  //=================================================================
  // FROM MAP
  //=================================================================

  factory MobileAttendanceModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return MobileAttendanceModel(
      // -------------------------------------------------------------
      // IDENTIFICATION
      // -------------------------------------------------------------

      id: map['id']?.toString(),

      companyId:
      map['company_id']?.toString(),

      employeeId:
      map['employee_id']?.toString(),

      departmentId:
      map['department_id']?.toString(),

      designationId:
      map['designation_id']?.toString(),

      shiftId:
      map['shift_id']?.toString(),

      // -------------------------------------------------------------
      // ATTENDANCE
      // -------------------------------------------------------------

      attendanceNo:
      map['attendance_no']?.toString() ?? '',

      attendanceDate:
      _parseRequiredDate(
        map['attendance_date'],
      ),

      checkInTime:
      _parseNullableDate(
        map['check_in_time'],
      ),

      checkOutTime:
      _parseNullableDate(
        map['check_out_time'],
      ),

      attendanceStatus:
      map['attendance_status']?.toString() ??
          'PRESENT',

      // -------------------------------------------------------------
      // CHECK-IN LOCATION
      // -------------------------------------------------------------

      checkInLatitude:
      _parseNullableDouble(
        map['check_in_latitude'],
      ),

      checkInLongitude:
      _parseNullableDouble(
        map['check_in_longitude'],
      ),

      checkInAddress:
      map['check_in_address']?.toString(),

      checkInAccuracy:
      _parseNullableDouble(
        map['check_in_accuracy'],
      ),

      // -------------------------------------------------------------
      // CHECK-OUT LOCATION
      // -------------------------------------------------------------

      checkOutLatitude:
      _parseNullableDouble(
        map['check_out_latitude'],
      ),

      checkOutLongitude:
      _parseNullableDouble(
        map['check_out_longitude'],
      ),

      checkOutAddress:
      map['check_out_address']?.toString(),

      checkOutAccuracy:
      _parseNullableDouble(
        map['check_out_accuracy'],
      ),

      // -------------------------------------------------------------
      // DEVICE
      // -------------------------------------------------------------

      deviceName:
      map['device_name']?.toString(),

      deviceId:
      map['device_id']?.toString(),

      ipAddress:
      map['ip_address']?.toString(),

      // -------------------------------------------------------------
      // OTHER
      // -------------------------------------------------------------

      remarks:
      map['remarks']?.toString(),

      isActive:
      _parseBool(
        map['is_active'],
      ),

      createdBy:
      map['created_by']?.toString(),

      updatedBy:
      map['updated_by']?.toString(),

      createdAt:
      _parseNullableDate(
        map['created_at'],
      ),

      updatedAt:
      _parseNullableDate(
        map['updated_at'],
      ),
    );
  }

  //=================================================================
  // FROM ENTITY
  //=================================================================

  factory MobileAttendanceModel.fromEntity(
      MobileAttendanceEntity entity,
      ) {
    return MobileAttendanceModel(
      // -------------------------------------------------------------
      // IDENTIFICATION
      // -------------------------------------------------------------

      id: entity.id,

      companyId:
      entity.companyId,

      employeeId:
      entity.employeeId,

      departmentId:
      entity.departmentId,

      designationId:
      entity.designationId,

      shiftId:
      entity.shiftId,

      // -------------------------------------------------------------
      // ATTENDANCE
      // -------------------------------------------------------------

      attendanceNo:
      entity.attendanceNo,

      attendanceDate:
      entity.attendanceDate,

      checkInTime:
      entity.checkInTime,

      checkOutTime:
      entity.checkOutTime,

      attendanceStatus:
      entity.attendanceStatus,

      // -------------------------------------------------------------
      // CHECK-IN LOCATION
      // -------------------------------------------------------------

      checkInLatitude:
      entity.checkInLatitude,

      checkInLongitude:
      entity.checkInLongitude,

      checkInAddress:
      entity.checkInAddress,

      checkInAccuracy:
      entity.checkInAccuracy,

      // -------------------------------------------------------------
      // CHECK-OUT LOCATION
      // -------------------------------------------------------------

      checkOutLatitude:
      entity.checkOutLatitude,

      checkOutLongitude:
      entity.checkOutLongitude,

      checkOutAddress:
      entity.checkOutAddress,

      checkOutAccuracy:
      entity.checkOutAccuracy,

      // -------------------------------------------------------------
      // DEVICE
      // -------------------------------------------------------------

      deviceName:
      entity.deviceName,

      deviceId:
      entity.deviceId,

      ipAddress:
      entity.ipAddress,

      // -------------------------------------------------------------
      // OTHER
      // -------------------------------------------------------------

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
    );
  }

  //=================================================================
  // INSERT MAP
  //
  // IMPORTANT:
  // ---------------------------------------------------------------
  // work_minutes নেই
  // overtime_minutes নেই
  // id নেই
  //
  // Database নিজে id generate করবে।
  //=================================================================

  Map<String, dynamic> toInsertMap() {
    return {
      // -------------------------------------------------------------
      // IDENTIFICATION
      // -------------------------------------------------------------

      'company_id':
      companyId,

      'employee_id':
      employeeId,

      'department_id':
      departmentId,

      'designation_id':
      designationId,

      'shift_id':
      shiftId,

      // -------------------------------------------------------------
      // ATTENDANCE
      // -------------------------------------------------------------

      'attendance_no':
      attendanceNo,

      'attendance_date':
      _formatDate(
        attendanceDate,
      ),

      'check_in_time':
      checkInTime?.toIso8601String(),

      'check_out_time':
      checkOutTime?.toIso8601String(),

      'attendance_status':
      attendanceStatus,

      // -------------------------------------------------------------
      // CHECK-IN LOCATION
      // -------------------------------------------------------------

      'check_in_latitude':
      checkInLatitude,

      'check_in_longitude':
      checkInLongitude,

      'check_in_address':
      checkInAddress,

      'check_in_accuracy':
      checkInAccuracy,

      // -------------------------------------------------------------
      // CHECK-OUT LOCATION
      // -------------------------------------------------------------

      'check_out_latitude':
      checkOutLatitude,

      'check_out_longitude':
      checkOutLongitude,

      'check_out_address':
      checkOutAddress,

      'check_out_accuracy':
      checkOutAccuracy,

      // -------------------------------------------------------------
      // DEVICE
      // -------------------------------------------------------------

      'device_name':
      deviceName,

      'device_id':
      deviceId,

      'ip_address':
      ipAddress,

      // -------------------------------------------------------------
      // OTHER
      // -------------------------------------------------------------

      'remarks':
      remarks,

      'is_active':
      isActive,

      'created_by':
      createdBy,

      'updated_by':
      updatedBy,
    };
  }

  //=================================================================
  // UPDATE MAP
  //
  // IMPORTANT:
  // ---------------------------------------------------------------
  // work_minutes নেই
  // overtime_minutes নেই
  // id নেই
  // created_at নেই
  //
  // Repository WHERE id = attendance.id দিয়ে update করবে।
  //=================================================================

  Map<String, dynamic> toUpdateMap() {
    return {
      // -------------------------------------------------------------
      // IDENTIFICATION
      // -------------------------------------------------------------

      'company_id':
      companyId,

      'employee_id':
      employeeId,

      'department_id':
      departmentId,

      'designation_id':
      designationId,

      'shift_id':
      shiftId,

      // -------------------------------------------------------------
      // ATTENDANCE
      // -------------------------------------------------------------

      'attendance_no':
      attendanceNo,

      'attendance_date':
      _formatDate(
        attendanceDate,
      ),

      'check_in_time':
      checkInTime?.toIso8601String(),

      'check_out_time':
      checkOutTime?.toIso8601String(),

      'attendance_status':
      attendanceStatus,

      // -------------------------------------------------------------
      // CHECK-IN LOCATION
      // -------------------------------------------------------------

      'check_in_latitude':
      checkInLatitude,

      'check_in_longitude':
      checkInLongitude,

      'check_in_address':
      checkInAddress,

      'check_in_accuracy':
      checkInAccuracy,

      // -------------------------------------------------------------
      // CHECK-OUT LOCATION
      // -------------------------------------------------------------

      'check_out_latitude':
      checkOutLatitude,

      'check_out_longitude':
      checkOutLongitude,

      'check_out_address':
      checkOutAddress,

      'check_out_accuracy':
      checkOutAccuracy,

      // -------------------------------------------------------------
      // DEVICE
      // -------------------------------------------------------------

      'device_name':
      deviceName,

      'device_id':
      deviceId,

      'ip_address':
      ipAddress,

      // -------------------------------------------------------------
      // OTHER
      // -------------------------------------------------------------

      'remarks':
      remarks,

      'is_active':
      isActive,

      'updated_by':
      updatedBy,

      'updated_at':
      DateTime.now().toIso8601String(),
    };
  }

  //=================================================================
  // DATE PARSING
  //=================================================================

  static DateTime _parseRequiredDate(
      dynamic value,
      ) {
    if (value == null) {
      throw const FormatException(
        'Attendance date is required.',
      );
    }

    final valueString =
    value.toString().trim();

    if (valueString.isEmpty) {
      throw const FormatException(
        'Attendance date is required.',
      );
    }

    return DateTime.parse(
      valueString,
    );
  }

  //=================================================================
  // NULLABLE DATE PARSING
  //=================================================================

  static DateTime? _parseNullableDate(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    final valueString =
    value.toString().trim();

    if (valueString.isEmpty) {
      return null;
    }

    return DateTime.tryParse(
      valueString,
    );
  }

  //=================================================================
  // DOUBLE PARSING
  //=================================================================

  static double? _parseNullableDouble(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    final valueString =
    value.toString().trim();

    if (valueString.isEmpty) {
      return null;
    }

    return double.tryParse(
      valueString,
    );
  }

  //=================================================================
  // BOOLEAN PARSING
  //=================================================================

  static bool _parseBool(
      dynamic value,
      ) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return true;
  }

  //=================================================================
  // DATE FORMAT
  //=================================================================

  static String _formatDate(
      DateTime date,
      ) {
    return date
        .toIso8601String()
        .split('T')
        .first;
  }
}