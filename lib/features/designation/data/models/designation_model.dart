import '../../domain/entities/designation_entity.dart';

class DesignationModel extends DesignationEntity {
  const DesignationModel({
    required super.id,
    required super.companyId,
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
      Map<String, dynamic> json,
      ) {
    return DesignationModel(
      id: json['id']?.toString() ?? '',
      companyId: json['company_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      grade: (json['grade'] as num?)?.toInt() ?? 1,
      displayOrder:
      (json['display_order'] as num?)?.toInt() ?? 0,
      baseSalary:
      (json['base_salary'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
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
      'grade': grade,
      'display_order': displayOrder,
      'base_salary': baseSalary,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}