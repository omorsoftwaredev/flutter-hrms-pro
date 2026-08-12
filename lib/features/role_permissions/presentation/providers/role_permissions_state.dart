import '../../domain/entities/role_permissions_view_entity.dart';

class RolePermissionsState {
  const RolePermissionsState({
    this.rolePermissions = const [],
    this.filteredRolePermissions = const [],
    this.selectedRolePermission,
    this.isLoading = false,
    this.isSaving = false,
    this.search = '',
    this.error,
  });

  // =============================================================
  // ROLE PERMISSIONS
  // =============================================================

  final List<RolePermissionsViewEntity> rolePermissions;

  // =============================================================
  // FILTERED ROLE PERMISSIONS
  // =============================================================

  final List<RolePermissionsViewEntity>
  filteredRolePermissions;

  // =============================================================
  // SELECTED ROLE PERMISSION
  // =============================================================

  final RolePermissionsViewEntity?
  selectedRolePermission;

  // =============================================================
  // LOADING
  // =============================================================

  final bool isLoading;

  // =============================================================
  // SAVING
  // =============================================================

  final bool isSaving;

  // =============================================================
  // SEARCH
  // =============================================================

  final String search;

  // =============================================================
  // ERROR
  // =============================================================

  final String? error;

  // =============================================================
  // GETTER
  // =============================================================

  List<RolePermissionsViewEntity>
  get filteredPermissions =>
      filteredRolePermissions;

  RolePermissionsViewEntity?
  get selectedPermission =>
      selectedRolePermission;

  // =============================================================
  // COPY WITH
  // =============================================================

  RolePermissionsState copyWith({
    List<RolePermissionsViewEntity>? rolePermissions,
    List<RolePermissionsViewEntity>?
    filteredRolePermissions,
    RolePermissionsViewEntity?
    selectedRolePermission,
    bool? isLoading,
    bool? isSaving,
    String? search,
    String? error,
  }) {
    return RolePermissionsState(
      rolePermissions:
      rolePermissions ?? this.rolePermissions,

      filteredRolePermissions:
      filteredRolePermissions ??
          this.filteredRolePermissions,

      selectedRolePermission:
      selectedRolePermission ??
          this.selectedRolePermission,

      isLoading:
      isLoading ?? this.isLoading,

      isSaving:
      isSaving ?? this.isSaving,

      search:
      search ?? this.search,

      error:
      error,
    );
  }
}