import '../../domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  const ShiftModel({
    required super.id,
    required super.companyId,

    // Identity
    required super.code,
    required super.name,
    required super.description,

    // Shift Time
    required super.startTime,
    required super.endTime,
    required super.breakMinutes,

    // Attendance Rules
    required super.graceInMinutes,
    required super.graceOutMinutes,
    required super.lateAfterMinutes,
    required super.halfDayAfterMinutes,

    // Additional Grace Rules
    required super.lateGraceMinutes,
    required super.earlyLeaveGraceMinutes,

    // Working Hour Rules
    required super.minimumWorkingHours,
    required super.halfDayThresholdHours,

    // Shift Type
    required super.isNightShift,
    required super.isFlexible,

    // Attendance Requirement
    required super.checkInRequired,
    required super.checkOutRequired,

    // Status
    required super.isActive,

    // Audit
    required super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.updatedBy,
  });

  factory ShiftModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ShiftModel(
      id: json['id']?.toString() ?? '',
      companyId: json['company_id']?.toString() ?? '',

      // Identity
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',

      // Shift Time
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      breakMinutes:
      (json['break_minutes'] as num?)?.toInt() ?? 60,

      // Attendance Rules
      graceInMinutes:
      (json['grace_in_minutes'] as num?)?.toInt() ?? 15,
      graceOutMinutes:
      (json['grace_out_minutes'] as num?)?.toInt() ?? 15,
      lateAfterMinutes:
      (json['late_after_minutes'] as num?)?.toInt() ?? 15,
      halfDayAfterMinutes:
      (json['half_day_after_minutes'] as num?)?.toInt() ?? 240,

      // Additional Grace Rules
      lateGraceMinutes:
      (json['late_grace_minutes'] as num?)?.toInt() ?? 15,
      earlyLeaveGraceMinutes:
      (json['early_leave_grace_minutes'] as num?)?.toInt() ?? 15,

      // Working Hour Rules
      minimumWorkingHours:
      (json['minimum_working_hours'] as num?)?.toDouble() ?? 8.00,
      halfDayThresholdHours:
      (json['half_day_threshold_hours'] as num?)?.toDouble() ?? 4.00,

      // Shift Type
      isNightShift:
      json['is_night_shift'] as bool? ?? false,
      isFlexible:
      json['is_flexible'] as bool? ?? false,

      // Attendance Requirement
      checkInRequired:
      json['check_in_required'] as bool? ?? true,
      checkOutRequired:
      json['check_out_required'] as bool? ?? true,

      // Status
      isActive:
      json['is_active'] as bool? ?? true,

      // Audit
      createdAt: DateTime.parse(
        json['created_at'].toString(),
      ),

      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(
        json['updated_at'].toString(),
      ),

      createdBy: json['created_by']?.toString(),
      updatedBy: json['updated_by']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,

      // Identity
      'code': code,
      'name': name,
      'description': description,

      // Shift Time
      'start_time': startTime,
      'end_time': endTime,
      'break_minutes': breakMinutes,

      // Attendance Rules
      'grace_in_minutes': graceInMinutes,
      'grace_out_minutes': graceOutMinutes,
      'late_after_minutes': lateAfterMinutes,
      'half_day_after_minutes': halfDayAfterMinutes,

      // Additional Grace Rules
      'late_grace_minutes': lateGraceMinutes,
      'early_leave_grace_minutes': earlyLeaveGraceMinutes,

      // Working Hour Rules
      'minimum_working_hours': minimumWorkingHours,
      'half_day_threshold_hours': halfDayThresholdHours,

      // Shift Type
      'is_night_shift': isNightShift,
      'is_flexible': isFlexible,

      // Attendance Requirement
      'check_in_required': checkInRequired,
      'check_out_required': checkOutRequired,

      // Status
      'is_active': isActive,

      // Audit
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}