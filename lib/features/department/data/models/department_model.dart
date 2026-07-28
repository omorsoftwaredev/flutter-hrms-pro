import '../../domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.id,
    required super.companyId,
    required super.code,
    required super.name,
    required super.description,
    required super.managerName,
    required super.phone,
    required super.email,
    required super.location,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
  });

  factory DepartmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DepartmentModel(
      id: json['id'] ?? '',
      companyId: json['company_id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      managerName: json['manager_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      location: json['location'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'],
      ),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(
        json['updated_at'],
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'code': code,
      'name': name,
      'description': description,
      'manager_name': managerName,
      'phone': phone,
      'email': email,
      'location': location,
      'is_active': isActive,
      'created_at':
      createdAt.toIso8601String(),
      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }
}