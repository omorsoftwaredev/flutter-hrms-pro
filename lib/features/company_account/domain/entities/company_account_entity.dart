//===============================================================
// lib/features/company_account/domain/entities/company_account_entity.dart
//===============================================================

class CompanyAccountEntity {
  final String? id;

  final String companyId;

  final String? companyName;

  final String username;

  final String passwordHash;

  final bool isActive;

  final bool mustChangePassword;

  final DateTime? lastLoginAt;

  final DateTime createdAt;

  final DateTime? updatedAt;

  final String? createdBy;

  final String? updatedBy;

  const CompanyAccountEntity({
    required this.id,
    required this.companyId,
    this.companyName,
    required this.username,
    required this.passwordHash,
    required this.isActive,
    required this.mustChangePassword,
    this.lastLoginAt,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  CompanyAccountEntity copyWith({
    String? id,
    String? companyId,
    String? companyName,
    String? username,
    String? passwordHash,
    bool? isActive,
    bool? mustChangePassword,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return CompanyAccountEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      isActive: isActive ?? this.isActive,
      mustChangePassword:
      mustChangePassword ?? this.mustChangePassword,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}