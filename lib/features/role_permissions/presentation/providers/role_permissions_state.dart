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


  final List<RolePermissionsViewEntity> rolePermissions;


  final List<RolePermissionsViewEntity> filteredRolePermissions;


  final RolePermissionsViewEntity? selectedRolePermission;


  final bool isLoading;


  final bool isSaving;


  final String search;


  final String? error;



  List<RolePermissionsViewEntity> get filteredPermissions =>
      filteredRolePermissions;



  RolePermissionsViewEntity? get selectedPermission =>
      selectedRolePermission;



  RolePermissionsState copyWith({

    List<RolePermissionsViewEntity>? rolePermissions,

    List<RolePermissionsViewEntity>? filteredRolePermissions,

    RolePermissionsViewEntity? selectedRolePermission,

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