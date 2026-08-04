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



  factory RolePermissionsModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return RolePermissionsModel(

      id:
      json['id'] ?? '',


      companyId:
      json['company_id'] ?? '',


      roleId:
      json['role_id'] ?? '',



      moduleName:
      json['module_name'] ?? '',



      canView:
      json['can_view'] ?? false,


      canCreate:
      json['can_create'] ?? false,


      canUpdate:
      json['can_update'] ?? false,


      canDelete:
      json['can_delete'] ?? false,


      canExport:
      json['can_export'] ?? false,


      canApprove:
      json['can_approve'] ?? false,



      createdAt:

      json['created_at'] != null

          ? DateTime.parse(
        json['created_at'],
      )

          : DateTime.now(),



      updatedAt:

      json['updated_at'] == null

          ? null

          : DateTime.parse(
        json['updated_at'],
      ),



      createdBy:
      json['created_by'],


      updatedBy:
      json['updated_by'],



      companyName:

      json['companies'] != null

          ? json['companies']['name']

          : null,



      roleName:

      json['roles'] != null

          ? json['roles']['role_name']

          : null,

    );

  }




  Map<String,dynamic> toCreateJson(){

    return {

      'company_id':
      companyId,


      'role_id':
      roleId,


      'module_name':
      moduleName,


      'can_view':
      canView,


      'can_create':
      canCreate,


      'can_update':
      canUpdate,


      'can_delete':
      canDelete,


      'can_export':
      canExport,


      'can_approve':
      canApprove,


      'created_at':
      createdAt.toIso8601String(),


      if(createdBy != null)
        'created_by':
        createdBy,

    };

  }





  Map<String,dynamic> toUpdateJson(){

    return {


      'module_name':
      moduleName,


      'can_view':
      canView,


      'can_create':
      canCreate,


      'can_update':
      canUpdate,


      'can_delete':
      canDelete,


      'can_export':
      canExport,


      'can_approve':
      canApprove,


      'updated_at':
      updatedAt?.toIso8601String(),



      if(updatedBy != null)
        'updated_by':
        updatedBy,

    };

  }





  RolePermissionsViewEntity toViewEntity(){

    return RolePermissionsViewEntity(

      permission: this,


      companyName:
      companyName ?? '-',


      roleName:
      roleName ?? '-',

    );

  }

}