class RoleEntity {
  const RoleEntity({
    required this.id,
    required this.companyId,
    required this.roleCode,
    required this.roleName,
    required this.description,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  final String id;

  final String companyId;

  final String roleCode;

  final String roleName;

  final String description;

  final bool isActive;

  final DateTime createdAt;

  final DateTime? updatedAt;

  final String? createdBy;

  final String? updatedBy;

  RoleEntity copyWith({
    String? id,
    String? companyId,
    String? roleCode,
    String? roleName,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return RoleEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      roleCode: roleCode ?? this.roleCode,
      roleName: roleName ?? this.roleName,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}