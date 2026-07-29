import '../../domain/entities/designation_entity.dart';

class DesignationModel extends DesignationEntity {
  const DesignationModel({
    required super.id,
    required super.companyId,
    required super.code,
    required super.name,
    required super.description,
    required super.grade,
    required super.displayOrder,
    required super.baseSalary,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DesignationModel.fromJson(
      Map<String, dynamic> json) {
    return DesignationModel(
      id: json['id'] ?? '',
      companyId: json['company_id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      grade: json['grade'] ?? 1,
      displayOrder:
      json['display_order'] ?? 0,
      baseSalary:
      (json['base_salary'] ?? 0)
          .toDouble(),
      isActive:
      json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'],
      ),
      updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(
        json['updated_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'code': code,
      'name': name,
      'description': description,
      'grade': grade,
      'display_order': displayOrder,
      'base_salary': baseSalary,
      'is_active': isActive,
      'created_at':
      createdAt.toIso8601String(),
      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }
}