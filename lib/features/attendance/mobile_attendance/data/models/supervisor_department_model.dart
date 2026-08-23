import '../../domain/entities/supervisor_department_entity.dart';

//=================================================================
// SUPERVISOR DEPARTMENT MODEL
//=================================================================

class SupervisorDepartmentModel
    extends SupervisorDepartmentEntity {
  const SupervisorDepartmentModel({
    required super.id,
    required super.companyId,
    required super.supervisorId,
    required super.departmentId,
    required super.departmentName,
    required super.departmentCode,
  });

  //=================================================================
  // FROM JSON
  //=================================================================

  factory SupervisorDepartmentModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final dynamic departmentJson =
    json['departments'];

    String departmentName = '';
    String departmentCode = '';

    //===============================================================
    // DEPARTMENT RELATION
    //===============================================================

    if (departmentJson is Map) {
      departmentName =
          departmentJson['name']?.toString().trim() ?? '';

      departmentCode =
          departmentJson['code']?.toString().trim() ?? '';
    }

    //===============================================================
    // FALLBACK — DIRECT FIELDS
    //===============================================================

    final directDepartmentName =
        json['department_name']?.toString().trim() ?? '';

    final directDepartmentCode =
        json['department_code']?.toString().trim() ?? '';

    if (directDepartmentName.isNotEmpty) {
      departmentName = directDepartmentName;
    }

    if (directDepartmentCode.isNotEmpty) {
      departmentCode = directDepartmentCode;
    }

    //===============================================================
    // CREATE MODEL
    //===============================================================

    return SupervisorDepartmentModel(
      id: json['id']?.toString() ?? '',
      companyId: json['company_id']?.toString() ?? '',
      supervisorId: json['supervisor_id']?.toString() ?? '',
      departmentId: json['department_id']?.toString() ?? '',
      departmentName: departmentName,
      departmentCode: departmentCode,
    );
  }

  //=================================================================
  // TO JSON
  //=================================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'supervisor_id': supervisorId,
      'department_id': departmentId,
      'department_name': departmentName,
      'department_code': departmentCode,
    };
  }

  //=================================================================
  // FROM ENTITY
  //=================================================================

  factory SupervisorDepartmentModel.fromEntity(
      SupervisorDepartmentEntity entity,
      ) {
    return SupervisorDepartmentModel(
      id: entity.id,
      companyId: entity.companyId,
      supervisorId: entity.supervisorId,
      departmentId: entity.departmentId,
      departmentName: entity.departmentName,
      departmentCode: entity.departmentCode,
    );
  }

  //=================================================================
  // COPY WITH
  //=================================================================

  @override
  SupervisorDepartmentModel copyWith({
    String? id,
    String? companyId,
    String? supervisorId,
    String? departmentId,
    String? departmentName,
    String? departmentCode,
  }) {
    return SupervisorDepartmentModel(
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
}