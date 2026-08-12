import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/role_repository.dart';
import '../models/role_model.dart';

class RoleRepositoryImpl implements RoleRepository {
  RoleRepositoryImpl(this._ref);

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
  // GET ROLES
  // =============================================================

  @override
  Future<List<RoleEntity>> getRoles() async {
    try {
      final companyId = _currentCompanyId;

      debugPrint(
        'Role List Company ID => $companyId',
      );

      final response = await _client
          .from('roles')
          .select()
          .eq('company_id', companyId)
          .order('role_name');

      final roles = (response as List)
          .map(
            (json) => RoleModel.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .toList();

      debugPrint(
        'Role List Count => ${roles.length}',
      );

      return roles;
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Roles Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Roles Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // GET ROLE BY ID
  // =============================================================

  @override
  Future<RoleEntity> getRoleById(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final roleId = id.trim();

      if (roleId.isEmpty) {
        throw Exception(
          'Role ID is required.',
        );
      }

      final response = await _client
          .from('roles')
          .select()
          .eq('id', roleId)
          .eq('company_id', companyId)
          .single();

      return RoleModel.fromJson(
        response as Map<String, dynamic>,
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Role Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Role Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // CREATE ROLE
  // =============================================================
  //
  // company_id:
  //   CurrentUser.companyId
  //
  // created_by:
  //   CurrentUser.userId
  //
  // role_code:
  //   Database trigger generate করবে।
  //
  // =============================================================

  @override
  Future<void> createRole(
      RoleEntity role,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      debugPrint('CREATE ROLE');
      debugPrint('Company ID => $companyId');
      debugPrint('Created By => $userId');

      await _client.from('roles').insert({
        'company_id': companyId,
        'role_name': role.roleName.trim(),
        'description': role.description.trim(),
        'is_active': role.isActive,
        'created_by': userId,

        // role_code manually পাঠানো হচ্ছে না।
        // Database trigger generate করবে।
      });

      debugPrint(
        'Role Created Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Create Role Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Create Role Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE ROLE
  // =============================================================
  //
  // company_id:
  //   CurrentUser.companyId দিয়ে scope হবে।
  //
  // created_by:
  //   পরিবর্তন হবে না।
  //
  // updated_by:
  //   CurrentUser.userId
  //
  // role_code:
  //   পরিবর্তন হবে না।
  //
  // updated_at:
  //   Database trigger handle করবে।
  //
  // =============================================================

  @override
  Future<void> updateRole(
      RoleEntity role,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final roleId = role.id.trim();

      if (roleId.isEmpty) {
        throw Exception(
          'Role ID is required for update.',
        );
      }

      debugPrint('UPDATE ROLE');
      debugPrint('Role ID => $roleId');
      debugPrint('Company ID => $companyId');
      debugPrint('Updated By => $userId');

      final response = await _client
          .from('roles')
          .update({
        'role_name': role.roleName.trim(),
        'description': role.description.trim(),
        'is_active': role.isActive,
        'updated_by': userId,

        // role_code update করছি না।
        // created_by update করছি না।
        // company_id update করছি না।
        // updated_at trigger handle করবে।
      })
          .eq('id', roleId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Role not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Role Updated Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Role Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Update Role Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE ROLE STATUS
  // =============================================================

  @override
  Future<void> updateRoleStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final roleId = id.trim();

      if (roleId.isEmpty) {
        throw Exception(
          'Role ID is required.',
        );
      }

      debugPrint('UPDATE ROLE STATUS');
      debugPrint('Role ID => $roleId');
      debugPrint('Company ID => $companyId');
      debugPrint('Updated By => $userId');
      debugPrint('Is Active => $isActive');

      final response = await _client
          .from('roles')
          .update({
        'is_active': isActive,
        'updated_by': userId,

        // updated_at trigger handle করবে।
      })
          .eq('id', roleId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Role not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Role Status Updated => $roleId',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Role Status Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Update Role Status Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // DELETE ROLE
  // =============================================================

  @override
  Future<void> deleteRole(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final roleId = id.trim();

      if (roleId.isEmpty) {
        throw Exception(
          'Role ID is required.',
        );
      }

      debugPrint('DELETE ROLE');
      debugPrint('Role ID => $roleId');
      debugPrint('Company ID => $companyId');

      final response = await _client
          .from('roles')
          .delete()
          .eq('id', roleId)
          .eq('company_id', companyId)
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Role not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Role Deleted => $roleId',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Delete Role Postgrest Error: '
            '${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Delete Role Error: $e',
      );

      rethrow;
    }
  }
}