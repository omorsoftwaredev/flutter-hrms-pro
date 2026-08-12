import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/current_user_provider.dart';

import '../../domain/entities/role_permissions_entity.dart';
import '../../domain/entities/role_permissions_view_entity.dart';
import '../../domain/repositories/role_permissions_repository.dart';

import '../models/role_permissions_model.dart';

class RolePermissionsRepositoryImpl
    implements RolePermissionsRepository {
  RolePermissionsRepositoryImpl(this._ref);

  final Ref _ref;

  final SupabaseClient _client =
      Supabase.instance.client;

  // =============================================================
  // CURRENT USER ID
  // =============================================================

  String get _currentUserId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception(
        'Current user information is not available.',
      );
    }

    final userId = user.userId.trim();

    if (userId.isEmpty) {
      throw Exception(
        'Current user ID is not available.',
      );
    }

    return userId;
  }

  // =============================================================
  // CURRENT COMPANY ID
  // =============================================================

  String get _currentCompanyId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception(
        'Current user information is not available.',
      );
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      throw Exception(
        'Company information is not available for this account.',
      );
    }

    return companyId;
  }

  // =============================================================
  // GET ROLE PERMISSIONS
  // =============================================================

  @override
  Future<List<RolePermissionsViewEntity>>
  getRolePermissions() async {
    try {
      final companyId = _currentCompanyId;

      debugPrint(
        'Role Permissions Company ID => $companyId',
      );

      final response = await _client
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
          .eq('company_id', companyId)
          .order('module_name');

      final permissions = (response as List)
          .map((e) {
        final model =
        RolePermissionsModel.fromJson(
          e as Map<String, dynamic>,
        );

        return model.toViewEntity();
      })
          .toList();

      debugPrint(
        'Role Permissions Count => ${permissions.length}',
      );

      return permissions;
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Role Permissions Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Role Permissions Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // GET ROLE PERMISSIONS BY ROLE ID
  // =============================================================

  @override
  Future<List<RolePermissionsViewEntity>>
  getRolePermissionsByRoleId(
      String roleId,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final id = roleId.trim();

      if (id.isEmpty) {
        throw Exception(
          'Role ID is required.',
        );
      }

      final response = await _client
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
          .eq('company_id', companyId)
          .eq('role_id', id)
          .order('module_name');

      return (response as List)
          .map((e) {
        final model =
        RolePermissionsModel.fromJson(
          e as Map<String, dynamic>,
        );

        return model.toViewEntity();
      })
          .toList();
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Role Permissions By Role Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Role Permissions By Role Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // GET ROLE PERMISSION BY ID
  // =============================================================

  @override
  Future<RolePermissionsViewEntity>
  getRolePermissionById(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final permissionId = id.trim();

      if (permissionId.isEmpty) {
        throw Exception(
          'Role Permission ID is required.',
        );
      }

      final response = await _client
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
          .eq('id', permissionId)
          .eq('company_id', companyId)
          .single();

      final model =
      RolePermissionsModel.fromJson(
        response as Map<String, dynamic>,
      );

      return model.toViewEntity();
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Role Permission Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Role Permission Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // CREATE ROLE PERMISSION
  // =============================================================
  //
  // company_id:
  //     CurrentUser.companyId
  //
  // created_by:
  //     CurrentUser.userId
  //
  // =============================================================

  @override
  Future<void> createRolePermission(
      RolePermissionsEntity rolePermission,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final roleId = rolePermission.roleId.trim();
      final moduleName =
      rolePermission.moduleName.trim();

      if (roleId.isEmpty) {
        throw Exception(
          'Role ID is required.',
        );
      }

      if (moduleName.isEmpty) {
        throw Exception(
          'Module name is required.',
        );
      }

      debugPrint('CREATE ROLE PERMISSION');
      debugPrint('Company ID => $companyId');
      debugPrint('Role ID => $roleId');
      debugPrint('Created By => $userId');

      final model = RolePermissionsModel(
        id: rolePermission.id,
        companyId: companyId,
        roleId: roleId,
        moduleName: moduleName,
        canView: rolePermission.canView,
        canCreate: rolePermission.canCreate,
        canUpdate: rolePermission.canUpdate,
        canDelete: rolePermission.canDelete,
        canExport: rolePermission.canExport,
        canApprove: rolePermission.canApprove,
        createdAt: rolePermission.createdAt,
        updatedAt: rolePermission.updatedAt,
        createdBy: userId,
        updatedBy: rolePermission.updatedBy,
      );

      await _client
          .from('role_permissions')
          .insert(
        model.toCreateJson(),
      );

      debugPrint(
        'Role Permission Created Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Create Role Permission Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Create Role Permission Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE ROLE PERMISSION
  // =============================================================

  @override
  Future<void> updateRolePermission(
      RolePermissionsEntity rolePermission,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final permissionId =
      rolePermission.id.trim();

      if (permissionId.isEmpty) {
        throw Exception(
          'Role Permission ID is required for update.',
        );
      }

      final roleId =
      rolePermission.roleId.trim();

      if (roleId.isEmpty) {
        throw Exception(
          'Role ID is required.',
        );
      }

      debugPrint('UPDATE ROLE PERMISSION');
      debugPrint(
        'Permission ID => $permissionId',
      );
      debugPrint('Company ID => $companyId');
      debugPrint('Updated By => $userId');

      final model = RolePermissionsModel(
        id: permissionId,
        companyId: companyId,
        roleId: roleId,
        moduleName:
        rolePermission.moduleName.trim(),
        canView: rolePermission.canView,
        canCreate: rolePermission.canCreate,
        canUpdate: rolePermission.canUpdate,
        canDelete: rolePermission.canDelete,
        canExport: rolePermission.canExport,
        canApprove: rolePermission.canApprove,
        createdAt: rolePermission.createdAt,
        updatedAt: DateTime.now(),
        createdBy: rolePermission.createdBy,
        updatedBy: userId,
      );

      final response = await _client
          .from('role_permissions')
          .update(
        model.toUpdateJson(),
      )
          .eq('id', permissionId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Role Permission not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Role Permission Updated Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Role Permission Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Update Role Permission Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // DELETE ROLE PERMISSION
  // =============================================================

  @override
  Future<void> deleteRolePermission(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final permissionId = id.trim();

      if (permissionId.isEmpty) {
        throw Exception(
          'Role Permission ID is required.',
        );
      }

      debugPrint('DELETE ROLE PERMISSION');
      debugPrint(
        'Permission ID => $permissionId',
      );
      debugPrint('Company ID => $companyId');

      final response = await _client
          .from('role_permissions')
          .delete()
          .eq('id', permissionId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Role Permission not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Role Permission Deleted => $permissionId',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Delete Role Permission Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Delete Role Permission Error: $e',
      );

      rethrow;
    }
  }
}