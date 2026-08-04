import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/role_permissions_entity.dart';
import '../../domain/entities/role_permissions_view_entity.dart';
import '../../domain/repositories/role_permissions_repository.dart';

import '../models/role_permissions_model.dart';


class RolePermissionsRepositoryImpl
    implements RolePermissionsRepository {


  RolePermissionsRepositoryImpl();


  final SupabaseClient _client =
      Supabase.instance.client;



  @override
  Future<List<RolePermissionsViewEntity>>
  getRolePermissions() async {


    final response =
    await _client
        .from('role_permissions')
        .select('''
          *,
          companies(
            name
          ),
          roles(
            role_name
          )
        ''')
        .order('module_name');



    return (response as List)
        .map((e) {


      final model =
      RolePermissionsModel.fromJson(
        e as Map<String,dynamic>,
      );


      return model.toViewEntity();


    })
        .toList();

  }





  @override
  Future<List<RolePermissionsViewEntity>>
  getRolePermissionsByRoleId(
      String roleId,
      ) async {


    final response =
    await _client
        .from('role_permissions')
        .select('''
          *,
          companies(
            name
          ),
          roles(
            role_name
          )
        ''')
        .eq(
      'role_id',
      roleId,
    )
        .order('module_name');



    return (response as List)
        .map((e) {


      final model =
      RolePermissionsModel.fromJson(
        e as Map<String,dynamic>,
      );


      return model.toViewEntity();


    })
        .toList();

  }





  @override
  Future<RolePermissionsViewEntity>
  getRolePermissionById(
      String id,
      ) async {


    final response =
    await _client
        .from('role_permissions')
        .select('''
          *,
          companies(
            name
          ),
          roles(
            role_name
          )
        ''')
        .eq(
      'id',
      id,
    )
        .single();



    final model =
    RolePermissionsModel.fromJson(
      response as Map<String,dynamic>,
    );



    return model.toViewEntity();

  }





  @override
  Future<void> createRolePermission(
      RolePermissionsEntity rolePermission,
      ) async {


    final model =
    RolePermissionsModel(

      id: rolePermission.id,

      companyId:
      rolePermission.companyId,

      roleId:
      rolePermission.roleId,

      moduleName:
      rolePermission.moduleName,


      canView:
      rolePermission.canView,

      canCreate:
      rolePermission.canCreate,

      canUpdate:
      rolePermission.canUpdate,

      canDelete:
      rolePermission.canDelete,

      canExport:
      rolePermission.canExport,

      canApprove:
      rolePermission.canApprove,


      createdAt:
      rolePermission.createdAt,


      updatedAt:
      rolePermission.updatedAt,


      createdBy:
      rolePermission.createdBy,


      updatedBy:
      rolePermission.updatedBy,

    );



    await _client
        .from('role_permissions')
        .insert(
      model.toCreateJson(),
    );

  }





  @override
  Future<void> updateRolePermission(
      RolePermissionsEntity rolePermission,
      ) async {


    final model =
    RolePermissionsModel(

      id: rolePermission.id,

      companyId:
      rolePermission.companyId,

      roleId:
      rolePermission.roleId,

      moduleName:
      rolePermission.moduleName,


      canView:
      rolePermission.canView,

      canCreate:
      rolePermission.canCreate,

      canUpdate:
      rolePermission.canUpdate,

      canDelete:
      rolePermission.canDelete,

      canExport:
      rolePermission.canExport,

      canApprove:
      rolePermission.canApprove,


      createdAt:
      rolePermission.createdAt,


      updatedAt:
      rolePermission.updatedAt,


      createdBy:
      rolePermission.createdBy,


      updatedBy:
      rolePermission.updatedBy,

    );



    await _client
        .from('role_permissions')
        .update(
      model.toUpdateJson(),
    )
        .eq(
      'id',
      rolePermission.id,
    );

  }





  @override
  Future<void> deleteRolePermission(
      String id,
      ) async {


    await _client
        .from('role_permissions')
        .delete()
        .eq(
      'id',
      id,
    );

  }


}