/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Entity
///
/// Version : 1.0.0
/// ===============================================================

class SupervisorDepartment {
  // =============================================================
  // ID
  // =============================================================

  final String id;

  // =============================================================
  // COMPANY
  // =============================================================

  final String companyId;

  // =============================================================
  // SUPERVISOR
  // =============================================================

  final String supervisorId;

  // =============================================================
  // DEPARTMENT
  // =============================================================

  final String departmentId;

  // =============================================================
  // CREATED AT
  // =============================================================

  final DateTime? createdAt;

  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  const SupervisorDepartment({
    required this.id,
    required this.companyId,
    required this.supervisorId,
    required this.departmentId,
    this.createdAt,
  });

  // =============================================================
  // EMPTY
  // =============================================================

  const SupervisorDepartment.empty()
      : id = '',
        companyId = '',
        supervisorId = '',
        departmentId = '',
        createdAt = null;

  // =============================================================
  // FROM MAP
  // =============================================================

  factory SupervisorDepartment.fromMap(
      Map<String, dynamic> map,
      ) {
    return SupervisorDepartment(
      id: map['id']?.toString() ?? '',
      companyId: map['company_id']?.toString() ?? '',
      supervisorId:
      map['supervisor_id']?.toString() ?? '',
      departmentId:
      map['department_id']?.toString() ?? '',
      createdAt: _parseDateTime(
        map['created_at'],
      ),
    );
  }

  // =============================================================
  // TO MAP
  // =============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'supervisor_id': supervisorId,
      'department_id': departmentId,
      if (createdAt != null)
        'created_at': createdAt!.toIso8601String(),
    };
  }

  // =============================================================
  // INSERT MAP
  // =============================================================

  Map<String, dynamic> toInsertMap() {
    return {
      'company_id': companyId,
      'supervisor_id': supervisorId,
      'department_id': departmentId,
    };
  }

  // =============================================================
  // COPY WITH
  // =============================================================

  SupervisorDepartment copyWith({
    String? id,
    String? companyId,
    String? supervisorId,
    String? departmentId,
    DateTime? createdAt,
  }) {
    return SupervisorDepartment(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      supervisorId:
      supervisorId ?? this.supervisorId,
      departmentId:
      departmentId ?? this.departmentId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // =============================================================
  // HELPERS
  // =============================================================

  bool get isValid {
    return id.isNotEmpty &&
        companyId.isNotEmpty &&
        supervisorId.isNotEmpty &&
        departmentId.isNotEmpty;
  }

  // =============================================================
  // DATETIME PARSER
  // =============================================================

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }

  // =============================================================
  // TO STRING
  // =============================================================

  @override
  String toString() {
    return '''
SupervisorDepartment(
  id: $id,
  companyId: $companyId,
  supervisorId: $supervisorId,
  departmentId: $departmentId,
  createdAt: $createdAt,
)
''';
  }
}