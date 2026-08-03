//===============================================================
// lib/features/company_account/data/models/company_account_model.dart
//===============================================================

import '../../domain/entities/company_account_entity.dart';

class CompanyAccountModel extends CompanyAccountEntity {
  const CompanyAccountModel({
    super.id,
    required super.companyId,
    super.companyName,
    required super.username,
    required super.passwordHash,
    required super.isActive,
    required super.mustChangePassword,
    super.lastLoginAt,
    required super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.updatedBy,
  });

  factory CompanyAccountModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CompanyAccountModel(
      id: json['id'],
      companyId: json['company_id'],
      companyName: json['companies']?['name'],
      username: json['username'],
      passwordHash: json['password'] ?? '',
      isActive: json['is_active'] ?? true,
      mustChangePassword:
      json['must_change_password'] ?? true,
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at']),
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'company_id': companyId,
      'username': username,
      'password': passwordHash,
      'is_active': isActive,
      'must_change_password': mustChangePassword,
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      'company_id': companyId,
      'username': username,
      'password': passwordHash,
      'is_active': isActive,
      'must_change_password': mustChangePassword,
      'updated_at': updatedAt?.toIso8601String(),
      'updated_by': updatedBy,
    };
  }
}