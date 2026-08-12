import 'package:flutter/foundation.dart';

@immutable
class EmployeeAccountEntity {
  const EmployeeAccountEntity({
    required this.id,

    required this.companyId,
    required this.departmentId,
    required this.employeeId,

    // =========================================================
    // DISPLAY / RELATION DATA
    // =========================================================

    this.employeeName,
    this.companyName,
    this.departmentName,

    // =========================================================
    // ACCOUNT
    // =========================================================

    required this.username,
    required this.passwordHash,

    this.canLogin = true,
    this.isActive = true,
    this.isLocked = false,

    this.failedLoginAttempts = 0,

    // =========================================================
    // LOGIN
    // =========================================================

    this.lastLoginAt,
    this.lastLoginIp,

    // =========================================================
    // PASSWORD
    // =========================================================

    this.passwordChangedAt,

    this.passwordResetToken,
    this.passwordResetExpireAt,

    this.forceChangePassword = true,
    this.passwordExpireAt,
    this.accountLockedAt,

    // =========================================================
    // AUDIT
    // =========================================================

    this.createdBy,
    this.createdAt,

    this.updatedBy,
    this.updatedAt,
  });

  // =============================================================
  // ID
  // =============================================================

  final String id;

  // =============================================================
  // COMPANY / RELATIONS
  // =============================================================

  final String companyId;
  final String departmentId;
  final String employeeId;

  // =============================================================
  // DISPLAY / RELATION DATA
  // =============================================================

  final String? employeeName;
  final String? companyName;
  final String? departmentName;

  // =============================================================
  // ACCOUNT
  // =============================================================

  final String username;
  final String passwordHash;

  final bool canLogin;
  final bool isActive;
  final bool isLocked;

  final int failedLoginAttempts;

  // =============================================================
  // LOGIN
  // =============================================================

  final DateTime? lastLoginAt;
  final String? lastLoginIp;

  // =============================================================
  // PASSWORD
  // =============================================================

  final DateTime? passwordChangedAt;

  final String? passwordResetToken;
  final DateTime? passwordResetExpireAt;

  final bool forceChangePassword;
  final DateTime? passwordExpireAt;
  final DateTime? accountLockedAt;

  // =============================================================
  // AUDIT
  // =============================================================

  final String? createdBy;
  final DateTime? createdAt;

  final String? updatedBy;
  final DateTime? updatedAt;

  // =============================================================
  // COPY WITH
  // =============================================================

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
      // ---------------------------------------------------------
      // ID
      // ---------------------------------------------------------

      id: id ?? this.id,

      // ---------------------------------------------------------
      // COMPANY / RELATIONS
      // ---------------------------------------------------------

      companyId:
      companyId ?? this.companyId,

      departmentId:
      departmentId ?? this.departmentId,

      employeeId:
      employeeId ?? this.employeeId,

      // ---------------------------------------------------------
      // DISPLAY
      // ---------------------------------------------------------

      employeeName:
      employeeName ?? this.employeeName,

      companyName:
      companyName ?? this.companyName,

      departmentName:
      departmentName ?? this.departmentName,

      // ---------------------------------------------------------
      // ACCOUNT
      // ---------------------------------------------------------

      username:
      username ?? this.username,

      passwordHash:
      passwordHash ?? this.passwordHash,

      canLogin:
      canLogin ?? this.canLogin,

      isActive:
      isActive ?? this.isActive,

      isLocked:
      isLocked ?? this.isLocked,

      failedLoginAttempts:
      failedLoginAttempts ??
          this.failedLoginAttempts,

      // ---------------------------------------------------------
      // LOGIN
      // ---------------------------------------------------------

      lastLoginAt:
      lastLoginAt ?? this.lastLoginAt,

      lastLoginIp:
      lastLoginIp ?? this.lastLoginIp,

      // ---------------------------------------------------------
      // PASSWORD
      // ---------------------------------------------------------

      passwordChangedAt:
      passwordChangedAt ??
          this.passwordChangedAt,

      passwordResetToken:
      passwordResetToken ??
          this.passwordResetToken,

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

      // ---------------------------------------------------------
      // AUDIT
      // ---------------------------------------------------------

      createdBy:
      createdBy ?? this.createdBy,

      createdAt:
      createdAt ?? this.createdAt,

      updatedBy:
      updatedBy ?? this.updatedBy,

      updatedAt:
      updatedAt ?? this.updatedAt,
    );
  }

  // =============================================================
  // EQUALITY
  // =============================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EmployeeAccountEntity &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  // =============================================================
  // HASH CODE
  // =============================================================

  @override
  int get hashCode => id.hashCode;

  // =============================================================
  // TO STRING
  // =============================================================

  @override
  String toString() {
    return 'EmployeeAccountEntity('
        'id: $id, '
        'companyId: $companyId, '
        'departmentId: $departmentId, '
        'employeeId: $employeeId, '
        'username: $username, '
        'employeeName: $employeeName, '
        'isActive: $isActive, '
        'isLocked: $isLocked, '
        'createdBy: $createdBy, '
        'updatedBy: $updatedBy'
        ')';
  }
}