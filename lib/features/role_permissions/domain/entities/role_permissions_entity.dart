import 'package:flutter/foundation.dart';

@immutable
class RolePermissionsEntity {
  const RolePermissionsEntity({
    required this.id,
    required this.companyId,
    required this.roleId,
    required this.moduleName,
    required this.canView,
    required this.canCreate,
    required this.canUpdate,
    required this.canDelete,
    required this.canExport,
    required this.canApprove,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  // =============================================================
  // BASIC
  // =============================================================

  final String id;

  final String companyId;

  final String roleId;

  final String moduleName;

  // =============================================================
  // PERMISSIONS
  // =============================================================

  final bool canView;

  final bool canCreate;

  final bool canUpdate;

  final bool canDelete;

  final bool canExport;

  final bool canApprove;

  // =============================================================
  // AUDIT
  // =============================================================

  final DateTime createdAt;

  final DateTime? updatedAt;

  final String? createdBy;

  final String? updatedBy;

  // =============================================================
  // COPY WITH
  // =============================================================

  RolePermissionsEntity copyWith({
    String? id,
    String? companyId,
    String? roleId,
    String? moduleName,
    bool? canView,
    bool? canCreate,
    bool? canUpdate,
    bool? canDelete,
    bool? canExport,
    bool? canApprove,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return RolePermissionsEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      roleId: roleId ?? this.roleId,
      moduleName: moduleName ?? this.moduleName,
      canView: canView ?? this.canView,
      canCreate: canCreate ?? this.canCreate,
      canUpdate: canUpdate ?? this.canUpdate,
      canDelete: canDelete ?? this.canDelete,
      canExport: canExport ?? this.canExport,
      canApprove: canApprove ?? this.canApprove,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  // =============================================================
  // EQUALITY
  // =============================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RolePermissionsEntity &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  // =============================================================
  // TO STRING
  // =============================================================

  @override
  String toString() {
    return 'RolePermissionsEntity('
        'id: $id, '
        'companyId: $companyId, '
        'roleId: $roleId, '
        'moduleName: $moduleName, '
        'canView: $canView, '
        'canCreate: $canCreate, '
        'canUpdate: $canUpdate, '
        'canDelete: $canDelete, '
        'canExport: $canExport, '
        'canApprove: $canApprove, '
        'createdBy: $createdBy, '
        'updatedBy: $updatedBy'
        ')';
  }
}