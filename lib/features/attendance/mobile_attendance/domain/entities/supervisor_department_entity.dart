//=================================================================
// SUPERVISOR DEPARTMENT ENTITY
//=================================================================

class SupervisorDepartmentEntity {
  final String id;
  final String companyId;
  final String supervisorId;
  final String departmentId;
  final String departmentName;
  final String departmentCode;

  const SupervisorDepartmentEntity({
    required this.id,
    required this.companyId,
    required this.supervisorId,
    required this.departmentId,
    required this.departmentName,
    required this.departmentCode,
  });

  //=================================================================
  // COPY WITH
  //=================================================================

  SupervisorDepartmentEntity copyWith({
    String? id,
    String? companyId,
    String? supervisorId,
    String? departmentId,
    String? departmentName,
    String? departmentCode,
  }) {
    return SupervisorDepartmentEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      supervisorId: supervisorId ?? this.supervisorId,
      departmentId: departmentId ?? this.departmentId,
      departmentName:
      departmentName ?? this.departmentName,
      departmentCode:
      departmentCode ?? this.departmentCode,
    );
  }

  //=================================================================
  // EQUALITY
  //=================================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SupervisorDepartmentEntity &&
        other.id == id &&
        other.companyId == companyId &&
        other.supervisorId == supervisorId &&
        other.departmentId == departmentId &&
        other.departmentName == departmentName &&
        other.departmentCode == departmentCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      companyId,
      supervisorId,
      departmentId,
      departmentName,
      departmentCode,
    );
  }

  //=================================================================
  // TO STRING
  //=================================================================

  @override
  String toString() {
    return 'SupervisorDepartmentEntity('
        'id: $id, '
        'companyId: $companyId, '
        'supervisorId: $supervisorId, '
        'departmentId: $departmentId, '
        'departmentName: $departmentName, '
        'departmentCode: $departmentCode'
        ')';
  }
}