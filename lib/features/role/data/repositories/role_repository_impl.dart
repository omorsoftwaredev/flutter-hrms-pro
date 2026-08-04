import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/role_repository.dart';
import '../models/role_model.dart';

class RoleRepositoryImpl implements RoleRepository {
  RoleRepositoryImpl();

  final SupabaseClient _client = Supabase.instance.client;


  @override
  Future<List<RoleEntity>> getRoles() async {
    final response = await _client
        .from('roles')
        .select()
        .order('role_name');

    return (response as List)
        .map(
          (e) => RoleModel.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  }


  @override
  Future<RoleEntity> getRoleById(String id) async {
    final response = await _client
        .from('roles')
        .select()
        .eq('id', id)
        .single();

    return RoleModel.fromJson(
      response as Map<String, dynamic>,
    );
  }


  @override
  Future<void> createRole(RoleEntity role) async {

    final roleModel = RoleModel(
      id: role.id,
      companyId: role.companyId,
      roleCode: role.roleCode,
      roleName: role.roleName,
      description: role.description,
      isActive: role.isActive,
      createdAt: role.createdAt,
      updatedAt: role.updatedAt,
      createdBy: role.createdBy,
      updatedBy: role.updatedBy,
    );


    await _client
        .from('roles')
        .insert(
      roleModel.toCreateJson(),
    );
  }



  @override
  Future<void> updateRole(RoleEntity role) async {

    final roleModel = RoleModel(
      id: role.id,
      companyId: role.companyId,
      roleCode: role.roleCode,
      roleName: role.roleName,
      description: role.description,
      isActive: role.isActive,
      createdAt: role.createdAt,
      updatedAt: role.updatedAt,
      createdBy: role.createdBy,
      updatedBy: role.updatedBy,
    );


    await _client
        .from('roles')
        .update(
      roleModel.toUpdateJson(),
    )
        .eq(
      'id',
      role.id,
    );
  }



  @override
  Future<void> deleteRole(String id) async {

    await _client
        .from('roles')
        .delete()
        .eq(
      'id',
      id,
    );
  }
}