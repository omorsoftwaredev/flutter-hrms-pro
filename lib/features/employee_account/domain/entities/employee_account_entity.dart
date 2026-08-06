class EmployeeAccountEntity {
  final String id;

  final String companyId;
  final String departmentId;
  final String employeeId;

  // Display fields
  final String? employeeName;
  final String? companyName;
  final String? departmentName;

  final String username;
  final String passwordHash;

  final bool canLogin;
  final bool isActive;
  final bool isLocked;

  final int failedLoginAttempts;

  final DateTime? lastLoginAt;
  final String? lastLoginIp;

  final DateTime? passwordChangedAt;

  final String? passwordResetToken;
  final DateTime? passwordResetExpireAt;

  final bool forceChangePassword;
  final DateTime? passwordExpireAt;
  final DateTime? accountLockedAt;

  final String? createdBy;
  final DateTime? createdAt;

  final String? updatedBy;
  final DateTime? updatedAt;

  const EmployeeAccountEntity({
    required this.id,

    required this.companyId,
    required this.departmentId,
    required this.employeeId,

    this.employeeName,
    this.companyName,
    this.departmentName,

    required this.username,
    required this.passwordHash,

    this.canLogin = true,
    this.isActive = true,
    this.isLocked = false,

    this.failedLoginAttempts = 0,

    this.lastLoginAt,
    this.lastLoginIp,

    this.passwordChangedAt,

    this.passwordResetToken,
    this.passwordResetExpireAt,

    this.forceChangePassword = true,
    this.passwordExpireAt,
    this.accountLockedAt,

    this.createdBy,
    this.createdAt,

    this.updatedBy,
    this.updatedAt,
  });

  EmployeeAccountEntity copyWith({
    String? id,

    String? companyId,
    String? departmentId,
    String? employeeId,

    String? employeeName,
    String? companyName,
    String? departmentName,

    String? username,
    String? passwordHash,

    bool? canLogin,
    bool? isActive,
    bool? isLocked,

    int? failedLoginAttempts,

    DateTime? lastLoginAt,
    String? lastLoginIp,

    DateTime? passwordChangedAt,

    String? passwordResetToken,
    DateTime? passwordResetExpireAt,

    bool? forceChangePassword,
    DateTime? passwordExpireAt,
    DateTime? accountLockedAt,

    String? createdBy,
    DateTime? createdAt,

    String? updatedBy,
    DateTime? updatedAt,
  }) {
    return EmployeeAccountEntity(
      id: id ?? this.id,

      companyId: companyId ?? this.companyId,
      departmentId: departmentId ?? this.departmentId,
      employeeId: employeeId ?? this.employeeId,

      employeeName: employeeName ?? this.employeeName,
      companyName: companyName ?? this.companyName,
      departmentName: departmentName ?? this.departmentName,

      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,

      canLogin: canLogin ?? this.canLogin,
      isActive: isActive ?? this.isActive,
      isLocked: isLocked ?? this.isLocked,

      failedLoginAttempts:
      failedLoginAttempts ?? this.failedLoginAttempts,

      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,

      passwordChangedAt:
      passwordChangedAt ?? this.passwordChangedAt,

      passwordResetToken:
      passwordResetToken ?? this.passwordResetToken,

      passwordResetExpireAt:
      passwordResetExpireAt ??
          this.passwordResetExpireAt,

      forceChangePassword:
      forceChangePassword ??
          this.forceChangePassword,

      passwordExpireAt:
      passwordExpireAt ??
          this.passwordExpireAt,

      accountLockedAt:
      accountLockedAt ??
          this.accountLockedAt,

      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,

      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}