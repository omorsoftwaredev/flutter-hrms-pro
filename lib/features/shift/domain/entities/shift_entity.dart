class ShiftEntity {
  const ShiftEntity({
    required this.id,
    required this.companyId,
    required this.code,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.breakMinutes,
    required this.graceInMinutes,
    required this.graceOutMinutes,
    required this.lateAfterMinutes,
    required this.halfDayAfterMinutes,
    required this.isNightShift,
    required this.isFlexible,
    this.weeklyOffDay,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  final String companyId;

  final String code;

  final String name;

  final String description;

  final String startTime;

  final String endTime;

  final int breakMinutes;

  final int graceInMinutes;

  final int graceOutMinutes;

  final int lateAfterMinutes;

  final int halfDayAfterMinutes;

  final bool isNightShift;

  final bool isFlexible;

  final int? weeklyOffDay;

  final bool isActive;

  final DateTime createdAt;

  final DateTime? updatedAt;
}