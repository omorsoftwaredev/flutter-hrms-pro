/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Model
///
/// Version : 3.0.0
/// ===============================================================

import '../../domain/entities/supervisor.dart';

class SupervisorModel extends Supervisor {
  const SupervisorModel({
    required super.id,
    required super.companyId,
    required super.departmentId,
    required super.employeeId,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SupervisorModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return SupervisorModel(
      id: map['id']?.toString() ?? '',
      companyId:
      map['company_id']?.toString() ?? '',
      departmentId:
      map['department_id']?.toString() ?? '',
      employeeId:
      map['employee_id']?.toString() ?? '',
      isActive:
      map['is_active'] as bool? ?? true,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(
        map['created_at'].toString(),
      )
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(
        map['updated_at'].toString(),
      )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'department_id': departmentId,
      'employee_id': employeeId,
      'is_active': isActive,
      'created_at':
      createdAt?.toIso8601String(),
      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }
}