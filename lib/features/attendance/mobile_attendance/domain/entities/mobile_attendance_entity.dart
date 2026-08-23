class MobileAttendanceEntity {
  //=================================================================
  // IDENTIFICATION
  //=================================================================

  final String? id;

  final String? companyId;

  final String? employeeId;

  final String? departmentId;

  final String? designationId;

  final String? shiftId;

  //=================================================================
  // ATTENDANCE INFORMATION
  //=================================================================

  final String attendanceNo;

  final DateTime attendanceDate;

  final DateTime? checkInTime;

  final DateTime? checkOutTime;

  final String attendanceStatus;

  //=================================================================
  // CHECK-IN LOCATION
  //=================================================================

  final double? checkInLatitude;

  final double? checkInLongitude;

  final String? checkInAddress;

  final double? checkInAccuracy;

  //=================================================================
  // CHECK-OUT LOCATION
  //=================================================================

  final double? checkOutLatitude;

  final double? checkOutLongitude;

  final String? checkOutAddress;

  final double? checkOutAccuracy;

  //=================================================================
  // DEVICE INFORMATION
  //=================================================================

  final String? deviceName;

  final String? deviceId;

  final String? ipAddress;

  //=================================================================
  // OTHER INFORMATION
  //=================================================================

  final String? remarks;

  final bool isActive;

  final String? createdBy;

  final String? updatedBy;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  //=================================================================
  // CONSTRUCTOR
  //=================================================================

  const MobileAttendanceEntity({
    this.id,
    this.companyId,
    this.employeeId,
    this.departmentId,
    this.designationId,
    this.shiftId,
    required this.attendanceNo,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.attendanceStatus = 'PRESENT',
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.deviceName,
    this.deviceId,
    this.ipAddress,
    this.remarks,
    this.isActive = true,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.checkInAddress,
    this.checkOutAddress,
    this.checkInAccuracy,
    this.checkOutAccuracy,
  });

  //=================================================================
  // COPY WITH
  //=================================================================

  MobileAttendanceEntity copyWith({
    String? id,
    String? companyId,
    String? employeeId,
    String? departmentId,
    String? designationId,
    String? shiftId,
    String? attendanceNo,
    DateTime? attendanceDate,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? attendanceStatus,
    double? checkInLatitude,
    double? checkInLongitude,
    double? checkOutLatitude,
    double? checkOutLongitude,
    String? deviceName,
    String? deviceId,
    String? ipAddress,
    String? remarks,
    bool? isActive,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? checkInAddress,
    String? checkOutAddress,
    double? checkInAccuracy,
    double? checkOutAccuracy,
  }) {
    return MobileAttendanceEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      employeeId: employeeId ?? this.employeeId,
      departmentId: departmentId ?? this.departmentId,
      designationId: designationId ?? this.designationId,
      shiftId: shiftId ?? this.shiftId,
      attendanceNo: attendanceNo ?? this.attendanceNo,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      attendanceStatus:
      attendanceStatus ?? this.attendanceStatus,
      checkInLatitude:
      checkInLatitude ?? this.checkInLatitude,
      checkInLongitude:
      checkInLongitude ?? this.checkInLongitude,
      checkOutLatitude:
      checkOutLatitude ?? this.checkOutLatitude,
      checkOutLongitude:
      checkOutLongitude ?? this.checkOutLongitude,
      deviceName:
      deviceName ?? this.deviceName,
      deviceId:
      deviceId ?? this.deviceId,
      ipAddress:
      ipAddress ?? this.ipAddress,
      remarks:
      remarks ?? this.remarks,
      isActive:
      isActive ?? this.isActive,
      createdBy:
      createdBy ?? this.createdBy,
      updatedBy:
      updatedBy ?? this.updatedBy,
      createdAt:
      createdAt ?? this.createdAt,
      updatedAt:
      updatedAt ?? this.updatedAt,
      checkInAddress:
      checkInAddress ?? this.checkInAddress,
      checkOutAddress:
      checkOutAddress ?? this.checkOutAddress,
      checkInAccuracy:
      checkInAccuracy ?? this.checkInAccuracy,
      checkOutAccuracy:
      checkOutAccuracy ?? this.checkOutAccuracy,
    );
  }
}