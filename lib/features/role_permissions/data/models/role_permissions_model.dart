import '../../domain/entities/role_permissions_entity.dart';
import '../../domain/entities/role_permissions_view_entity.dart';

class RolePermissionsModel extends RolePermissionsEntity {
  const RolePermissionsModel({
    required super.id,
    required super.companyId,
    required super.roleId,
    required super.moduleName,
    required super.canView,
    required super.canCreate,
    required super.canUpdate,
    required super.canDelete,
    required super.canExport,
    required super.canApprove,
    required super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.updatedBy,
    this.companyName,
    this.roleName,
  });

  final String? companyName;
  final String? roleName;

  // =============================================================
  // FROM JSON
  // =============================================================

  factory RolePermissionsModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RolePermissionsModel(
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
      // ROLE
      // ---------------------------------------------------------

      roleId:
      json['role_id']?.toString() ?? '',

      // ---------------------------------------------------------
      // MODULE
      // ---------------------------------------------------------

      moduleName:
      json['module_name']?.toString() ?? '',

      // ---------------------------------------------------------
      // PERMISSIONS
      // ---------------------------------------------------------

      canView:
      json['can_view'] == true,

      canCreate:
      json['can_create'] == true,

      canUpdate:
      json['can_update'] == true,

      canDelete:
      json['can_delete'] == true,

      canExport:
      json['can_export'] == true,

      canApprove:
      json['can_approve'] == true,

      // ---------------------------------------------------------
      // CREATED AT
      // ---------------------------------------------------------

      createdAt:
      json['created_at'] != null
          ? DateTime.parse(
        json['created_at'].toString(),
      )
          : DateTime.now(),

      // ---------------------------------------------------------
      // UPDATED AT
      // ---------------------------------------------------------

      updatedAt:
      json['updated_at'] != null
          ? DateTime.parse(
        json['updated_at'].toString(),
      )
          : null,

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
      // COMPANY NAME
      // ---------------------------------------------------------

      companyName:
      json['companies'] is Map
          ? json['companies']['name']?.toString()
          : null,

      // ---------------------------------------------------------
      // ROLE NAME
      // ---------------------------------------------------------

      roleName:
      json['roles'] is Map
          ? json['roles']['role_name']?.toString()
          : null,
    );
  }

  // =============================================================
  // TO CREATE JSON
  // =============================================================

  Map<String, dynamic> toCreateJson() {
    return {
      'company_id': companyId,
      'role_id': roleId,
      'module_name': moduleName,

      'can_view': canView,
      'can_create': canCreate,
      'can_update': canUpdate,
      'can_delete': canDelete,
      'can_export': canExport,
      'can_approve': canApprove,

      'created_at':
      createdAt.toIso8601String(),

      if (createdBy != null)
        'created_by': createdBy,
    };
  }

  // =============================================================
  // TO UPDATE JSON
  // =============================================================

  Map<String, dynamic> toUpdateJson() {
    return {
      'module_name': moduleName,

      'can_view': canView,
      'can_create': canCreate,
      'can_update': canUpdate,
      'can_delete': canDelete,
      'can_export': canExport,
      'can_approve': canApprove,

      if (updatedAt != null)
        'updated_at':
        updatedAt!.toIso8601String(),

      if (updatedBy != null)
        'updated_by': updatedBy,
    };
  }

  // =============================================================
  // TO VIEW ENTITY
  // =============================================================

  RolePermissionsViewEntity toViewEntity() {
    return RolePermissionsViewEntity(
      permission: this,
      companyName: companyName ?? '-',
      roleName: roleName ?? '-',
    );
  }
}