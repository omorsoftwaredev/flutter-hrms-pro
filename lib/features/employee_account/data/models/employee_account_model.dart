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

  factory EmployeeAccountModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return EmployeeAccountModel(
      id: json['id'] ?? '',

      companyId: json['company_id'] ?? '',
      departmentId: json['department_id'] ?? '',
      employeeId: json['employee_id'] ?? '',

      // Relation Data
      employeeName: json['employees']?['full_name'],
      departmentName: json['departments']?['name'],
      companyName: json['companies']?['name'],

      username: json['username'] ?? '',
      passwordHash: json['password_hash'] ?? '',

      canLogin: json['can_login'] ?? true,
      isActive: json['is_active'] ?? true,
      isLocked: json['is_locked'] ?? false,

      failedLoginAttempts:
      json['failed_login_attempts'] ?? 0,

      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,

      lastLoginIp: json['last_login_ip'],

      passwordChangedAt:
      json['password_changed_at'] != null
          ? DateTime.parse(
        json['password_changed_at'],
      )
          : null,

      passwordResetToken:
      json['password_reset_token'],

      passwordResetExpireAt:
      json['password_reset_expire_at'] != null
          ? DateTime.parse(
        json['password_reset_expire_at'],
      )
          : null,

      forceChangePassword:
      json['force_change_password'] ?? true,

      passwordExpireAt:
      json['password_expire_at'] != null
          ? DateTime.parse(
        json['password_expire_at'],
      )
          : null,

      accountLockedAt:
      json['account_locked_at'] != null
          ? DateTime.parse(
        json['account_locked_at'],
      )
          : null,

      createdBy: json['created_by'],

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,

      updatedBy: json['updated_by'],

      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  factory EmployeeAccountModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return EmployeeAccountModel.fromJson(map);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'company_id': companyId,
      'department_id': departmentId,
      'employee_id': employeeId,

      // Display fields (DB-তে যাবে না)
      'employee_name': employeeName,
      'department_name': departmentName,
      'company_name': companyName,

      'username': username,
      'password_hash': passwordHash,

      'can_login': canLogin,
      'is_active': isActive,
      'is_locked': isLocked,

      'failed_login_attempts':
      failedLoginAttempts,

      'last_login_at':
      lastLoginAt?.toIso8601String(),

      'last_login_ip': lastLoginIp,

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

      'created_by': createdBy,
      'created_at':
      createdAt?.toIso8601String(),

      'updated_by': updatedBy,
      'updated_at':
      updatedAt?.toIso8601String(),
    };
  }
}