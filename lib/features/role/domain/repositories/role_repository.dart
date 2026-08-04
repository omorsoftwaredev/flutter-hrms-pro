import '../entities/role_entity.dart';

abstract class RoleRepository {
  Future<List<RoleEntity>> getRoles();

  Future<RoleEntity> getRoleById(String id);

  Future<void> createRole(RoleEntity role);

  Future<void> updateRole(RoleEntity role);

  Future<void> deleteRole(String id);
}