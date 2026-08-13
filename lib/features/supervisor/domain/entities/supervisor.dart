/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Entity
///
/// Version : 3.0.0
/// ===============================================================

class Supervisor {
  final String id;
  final String companyId;
  final String departmentId;
  final String employeeId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final String? updatedBy;

  const Supervisor({
    required this.id,
    required this.companyId,
    required this.departmentId,
    required this.employeeId,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  // =============================================================
  // FROM MAP
  // =============================================================

  factory Supervisor.fromMap(
      Map<String, dynamic> map,
      ) {
    return Supervisor(
      id: map['id']?.toString() ?? '',
      companyId: map['company_id']?.toString() ?? '',
      departmentId: map['department_id']?.toString() ?? '',
      employeeId: map['employee_id']?.toString() ?? '',
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
      createdBy: map['created_by']?.toString() ?? '',
      updatedBy: map['updated_by']?.toString() ?? '',
    );
  }

  // =============================================================
  // TO MAP
  // =============================================================

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
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}