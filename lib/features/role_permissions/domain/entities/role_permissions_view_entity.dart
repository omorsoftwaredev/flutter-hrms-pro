import 'package:flutter/foundation.dart';

import 'role_permissions_entity.dart';

@immutable
class RolePermissionsViewEntity {
  const RolePermissionsViewEntity({
    required this.permission,
    required this.companyName,
    required this.roleName,
  });

  // =============================================================
  // DATA
  // =============================================================

  final RolePermissionsEntity permission;

  final String companyName;

  final String roleName;

  // =============================================================
  // COPY WITH
  // =============================================================

  RolePermissionsViewEntity copyWith({
    RolePermissionsEntity? permission,
    String? companyName,
    String? roleName,
  }) {
    return RolePermissionsViewEntity(
      permission: permission ?? this.permission,
      companyName: companyName ?? this.companyName,
      roleName: roleName ?? this.roleName,
    );
  }

  // =============================================================
  // EQUALITY
  // =============================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RolePermissionsViewEntity &&
            runtimeType == other.runtimeType &&
            permission == other.permission &&
            companyName == other.companyName &&
            roleName == other.roleName;
  }

  @override
  int get hashCode {
    return Object.hash(
      permission,
      companyName,
      roleName,
    );
  }

  // =============================================================
  // TO STRING
  // =============================================================

  @override
  String toString() {
    return 'RolePermissionsViewEntity('
        'permission: $permission, '
        'companyName: $companyName, '
        'roleName: $roleName'
        ')';
  }
}