class DesignationEntity {
  const DesignationEntity({
    required this.id,
    required this.companyId,
    required this.code,
    required this.name,
    required this.description,
    required this.grade,
    required this.displayOrder,
    required this.baseSalary,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String companyId;

  final String code;
  final String name;
  final String description;

  final int grade;
  final int displayOrder;

  final double baseSalary;

  final bool isActive;

  final DateTime createdAt;
  final DateTime? updatedAt;
}