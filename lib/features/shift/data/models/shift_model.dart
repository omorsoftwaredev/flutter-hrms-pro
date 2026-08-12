import '../../domain/entities/shift_entity.dart';

class ShiftModel extends ShiftEntity {
  const ShiftModel({
    required super.id,
    required super.companyId,
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
      Map<String, dynamic> json,
      ) {
    return ShiftModel(
      id: json['id']?.toString() ?? '',
      companyId: json['company_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      breakMinutes:
      (json['break_minutes'] as num?)?.toInt() ?? 60,
      graceInMinutes:
      (json['grace_in_minutes'] as num?)?.toInt() ?? 15,
      graceOutMinutes:
      (json['grace_out_minutes'] as num?)?.toInt() ?? 15,
      lateAfterMinutes:
      (json['late_after_minutes'] as num?)?.toInt() ?? 15,
      halfDayAfterMinutes:
      (json['half_day_after_minutes'] as num?)?.toInt() ??
          240,
      isNightShift:
      json['is_night_shift'] as bool? ?? false,
      isFlexible:
      json['is_flexible'] as bool? ?? false,
      weeklyOffDay: json['weekly_off_day'],
      isActive:
      json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(
        json['created_at'].toString(),
      ),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(
        json['updated_at'].toString(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'break_minutes': breakMinutes,
      'grace_in_minutes': graceInMinutes,
      'grace_out_minutes': graceOutMinutes,
      'late_after_minutes': lateAfterMinutes,
      'half_day_after_minutes': halfDayAfterMinutes,
      'is_night_shift': isNightShift,
      'is_flexible': isFlexible,
      'weekly_off_day': weeklyOffDay,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}