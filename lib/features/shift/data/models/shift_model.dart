import '../../domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  const ShiftModel({
    required super.id,
    required super.companyId,
    required super.code,
    required super.name,
    required super.description,
    required super.startTime,
    required super.endTime,
    required super.breakMinutes,
    required super.graceInMinutes,
    required super.graceOutMinutes,
    required super.lateAfterMinutes,
    required super.halfDayAfterMinutes,
    required super.isNightShift,
    required super.isFlexible,
    super.weeklyOffDay,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory ShiftModel.fromJson(
      Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'],
      companyId: json['company_id'],
      code: json['code'],
      name: json['name'],
      description:
      json['description'] ?? '',
      startTime: json['start_time'],
      endTime: json['end_time'],
      breakMinutes:
      json['break_minutes'] ?? 60,
      graceInMinutes:
      json['grace_in_minutes'] ?? 15,
      graceOutMinutes:
      json['grace_out_minutes'] ?? 15,
      lateAfterMinutes:
      json['late_after_minutes'] ?? 15,
      halfDayAfterMinutes:
      json['half_day_after_minutes'] ??
          240,
      isNightShift:
      json['is_night_shift'] ??
          false,
      isFlexible:
      json['is_flexible'] ?? false,
      weeklyOffDay:
      json['weekly_off_day'],
      isActive:
      json['is_active'] ?? true,
      createdAt: DateTime.parse(
          json['created_at']),
      updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(
          json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'code': code,
      'name': name,
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'break_minutes': breakMinutes,
      'grace_in_minutes':
      graceInMinutes,
      'grace_out_minutes':
      graceOutMinutes,
      'late_after_minutes':
      lateAfterMinutes,
      'half_day_after_minutes':
      halfDayAfterMinutes,
      'is_night_shift':
      isNightShift,
      'is_flexible':
      isFlexible,
      'weekly_off_day':
      weeklyOffDay,
      'is_active': isActive,
    };
  }
}