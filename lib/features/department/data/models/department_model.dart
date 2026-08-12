import '../../domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.id,
    required super.companyId,
    required super.name,
    required super.description,
    required super.phone,
    required super.email,
    required super.location,
    required super.isActive,
    required super.createdAt,
    super.createdBy,
    super.updatedAt,
    super.updatedBy,
  });

  // =============================================================
  // FROM JSON
  // =============================================================

  factory DepartmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DepartmentModel(
      // ---------------------------------------------------------
      // ID
      // ---------------------------------------------------------

      id: json['id']?.toString() ?? '',

      // ---------------------------------------------------------
      // COMPANY
      // ---------------------------------------------------------

      companyId:
      json['company_id']?.toString() ?? '',

      // ---------------------------------------------------------
      // DEPARTMENT
      // ---------------------------------------------------------

      name:
      json['name']?.toString() ?? '',

      description:
      json['description']?.toString() ?? '',

      phone:
      json['phone']?.toString() ?? '',

      email:
      json['email']?.toString() ?? '',

      location:
      json['location']?.toString() ?? '',

      isActive:
      json['is_active'] ?? true,

      // ---------------------------------------------------------
      // CREATED BY
      // ---------------------------------------------------------

      createdBy:
      json['created_by']?.toString(),

      // ---------------------------------------------------------
      // UPDATED BY
      // ---------------------------------------------------------

      updatedBy:
      json['updated_by']?.toString(),

      // ---------------------------------------------------------
      // CREATED AT
      // ---------------------------------------------------------

      createdAt: DateTime.parse(
        json['created_at'].toString(),
      ),

      // ---------------------------------------------------------
      // UPDATED AT
      // ---------------------------------------------------------

      updatedAt:
      json['updated_at'] != null
          ? DateTime.parse(
        json['updated_at'].toString(),
      )
          : null,
    );
  }

  // =============================================================
  // TO JSON
  // =============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,

      'name': name,
      'description': description,
      'phone': phone,
      'email': email,
      'location': location,

      'is_active': isActive,

      'created_by': createdBy,
      'updated_by': updatedBy,

      'created_at':
      createdAt.toIso8601String(),

      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }
}