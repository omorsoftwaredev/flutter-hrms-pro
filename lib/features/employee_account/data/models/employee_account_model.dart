import '../../domain/entities/employee_account_entity.dart';

class EmployeeAccountModel extends EmployeeAccountEntity {
  const EmployeeAccountModel({
    required super.id,
    required super.companyId,
    required super.departmentId,
    required super.employeeId,

    super.employeeName,
    super.departmentName,
    super.companyName,

    required super.username,
    required super.passwordHash,

    super.canLogin,
    super.isActive,
    super.isLocked,
    super.failedLoginAttempts,

    super.lastLoginAt,
    super.lastLoginIp,

    super.passwordChangedAt,

    super.passwordResetToken,
    super.passwordResetExpireAt,

    super.forceChangePassword,
    super.passwordExpireAt,
    super.accountLockedAt,

    super.createdBy,
    super.createdAt,

    super.updatedBy,
    super.updatedAt,
  });

  // =============================================================
  // FROM JSON
  // =============================================================

  factory EmployeeAccountModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return EmployeeAccountModel(
      // ---------------------------------------------------------
      // ID
      // ---------------------------------------------------------

      id: json['id']?.toString() ?? '',

      // ---------------------------------------------------------
      // COMPANY
      // ---------------------------------------------------------

      companyId:
      json['company_id']?.toString() ?? '',

      // ---------------------------------------------------------
      // DEPARTMENT
      // ---------------------------------------------------------

      departmentId:
      json['department_id']?.toString() ?? '',

      // ---------------------------------------------------------
      // EMPLOYEE
      // ---------------------------------------------------------

      employeeId:
      json['employee_id']?.toString() ?? '',

      // ---------------------------------------------------------
      // RELATION DATA
      // ---------------------------------------------------------

      employeeName:
      json['employees'] is Map<String, dynamic>
          ? json['employees']['full_name']?.toString()
          : null,

      departmentName:
      json['departments'] is Map<String, dynamic>
          ? json['departments']['name']?.toString()
          : null,

      companyName:
      json['companies'] is Map<String, dynamic>
          ? json['companies']['name']?.toString()
          : null,

      // ---------------------------------------------------------
      // ACCOUNT
      // ---------------------------------------------------------

      username:
      json['username']?.toString() ?? '',

      passwordHash:
      json['password_hash']?.toString() ?? '',

      canLogin:
      json['can_login'] ?? true,

      isActive:
      json['is_active'] ?? true,

      isLocked:
      json['is_locked'] ?? false,

      failedLoginAttempts:
      json['failed_login_attempts'] ?? 0,

      // ---------------------------------------------------------
      // LOGIN
      // ---------------------------------------------------------

      lastLoginAt:
      json['last_login_at'] != null
          ? DateTime.parse(
        json['last_login_at'].toString(),
      )
          : null,

      lastLoginIp:
      json['last_login_ip']?.toString(),

      // ---------------------------------------------------------
      // PASSWORD
      // ---------------------------------------------------------

      passwordChangedAt:
      json['password_changed_at'] != null
          ? DateTime.parse(
        json['password_changed_at'].toString(),
      )
          : null,

      passwordResetToken:
      json['password_reset_token']?.toString(),

      passwordResetExpireAt:
      json['password_reset_expire_at'] != null
          ? DateTime.parse(
        json['password_reset_expire_at']
            .toString(),
      )
          : null,

      forceChangePassword:
      json['force_change_password'] ?? true,

      passwordExpireAt:
      json['password_expire_at'] != null
          ? DateTime.parse(
        json['password_expire_at'].toString(),
      )
          : null,

      accountLockedAt:
      json['account_locked_at'] != null
          ? DateTime.parse(
        json['account_locked_at'].toString(),
      )
          : null,

      // ---------------------------------------------------------
      // CREATED BY
      // ---------------------------------------------------------

      createdBy:
      json['created_by']?.toString(),

      // ---------------------------------------------------------
      // UPDATED BY
      // ---------------------------------------------------------

      updatedBy:
      json['updated_by']?.toString(),

      // ---------------------------------------------------------
      // CREATED AT
      // ---------------------------------------------------------

      createdAt:
      json['created_at'] != null
          ? DateTime.parse(
        json['created_at'].toString(),
      )
          : DateTime.now(),

      // ---------------------------------------------------------
      // UPDATED AT
      // ---------------------------------------------------------

      updatedAt:
      json['updated_at'] != null
          ? DateTime.parse(
        json['updated_at'].toString(),
      )
          : null,
    );
  }

  // =============================================================
  // FROM MAP
  // =============================================================

  factory EmployeeAccountModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return EmployeeAccountModel.fromJson(map);
  }

  // =============================================================
  // TO JSON
  // =============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'company_id': companyId,

      'department_id': departmentId,

      'employee_id': employeeId,

      // ---------------------------------------------------------
      // ACCOUNT
      // ---------------------------------------------------------

      'username': username,

      'password_hash': passwordHash,

      'can_login': canLogin,

      'is_active': isActive,

      'is_locked': isLocked,

      'failed_login_attempts':
      failedLoginAttempts,

      // ---------------------------------------------------------
      // LOGIN
      // ---------------------------------------------------------

      'last_login_at':
      lastLoginAt?.toIso8601String(),

      'last_login_ip':
      lastLoginIp,

      // ---------------------------------------------------------
      // PASSWORD
      // ---------------------------------------------------------

      'password_changed_at':
      passwordChangedAt?.toIso8601String(),

      'password_reset_token':
      passwordResetToken,

      'password_reset_expire_at':
      passwordResetExpireAt
          ?.toIso8601String(),

      'force_change_password':
      forceChangePassword,

      'password_expire_at':
      passwordExpireAt
          ?.toIso8601String(),

      'account_locked_at':
      accountLockedAt
          ?.toIso8601String(),

      // ---------------------------------------------------------
      // CREATED BY
      // ---------------------------------------------------------

      'created_by':
      createdBy,

      // ---------------------------------------------------------
      // UPDATED BY
      // ---------------------------------------------------------

      'updated_by':
      updatedBy,

      // ---------------------------------------------------------
      // CREATED AT
      // ---------------------------------------------------------

      'created_at':
      createdAt?.toIso8601String(),

      // ---------------------------------------------------------
      // UPDATED AT
      // ---------------------------------------------------------

      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }
}