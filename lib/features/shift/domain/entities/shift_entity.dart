class ShiftEntity {
  const ShiftEntity({
    required this.id,
    required this.companyId,

    // Identity
    required this.code,
    required this.name,
    required this.description,

    // Shift Time
    required this.startTime,
    required this.endTime,
    required this.breakMinutes,

    // Attendance Rules
    required this.graceInMinutes,
    required this.graceOutMinutes,
    required this.lateAfterMinutes,
    required this.halfDayAfterMinutes,

    // Additional Grace Rules
    required this.lateGraceMinutes,
    required this.earlyLeaveGraceMinutes,

    // Working Hour Rules
    required this.minimumWorkingHours,
    required this.halfDayThresholdHours,

    // Shift Type
    required this.isNightShift,
    required this.isFlexible,

    // Attendance Requirement
    required this.checkInRequired,
    required this.checkOutRequired,

    // Status
    required this.isActive,

    // Audit
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  final String id;
  final String companyId;

  // Identity
  final String code;
  final String name;
  final String description;

  // Shift Time
  final String startTime;
  final String endTime;
  final int breakMinutes;

  // Attendance Rules
  final int graceInMinutes;
  final int graceOutMinutes;
  final int lateAfterMinutes;
  final int halfDayAfterMinutes;

  // Additional Grace Rules
  final int lateGraceMinutes;
  final int earlyLeaveGraceMinutes;

  // Working Hour Rules
  final double minimumWorkingHours;
  final double halfDayThresholdHours;

  // Shift Type
  final bool isNightShift;
  final bool isFlexible;

  // Attendance Requirement
  final bool checkInRequired;
  final bool checkOutRequired;

  // Status
  final bool isActive;

  // Audit
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final String? updatedBy;
}