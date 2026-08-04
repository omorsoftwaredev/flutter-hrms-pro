import '../../domain/entities/role_entity.dart';

class RoleState {
  const RoleState({
    this.roles = const [],
    this.filteredRoles = const [],
    this.selectedRole,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  final List<RoleEntity> roles;

  final List<RoleEntity> filteredRoles;

  final RoleEntity? selectedRole;

  final bool isLoading;

  final bool isSaving;

  final String search;

  final String? error;

  RoleState copyWith({
    List<RoleEntity>? roles,
    List<RoleEntity>? filteredRoles,
    RoleEntity? selectedRole,
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
  }) {
    return RoleState(
      roles: roles ?? this.roles,
      filteredRoles:
      filteredRoles ?? this.filteredRoles,
      selectedRole:
      selectedRole ?? this.selectedRole,
      isLoading:
      isLoading ?? this.isLoading,
      isSaving:
      isSaving ?? this.isSaving,
      search: search ?? this.search,
      error: error,
    );
  }
}