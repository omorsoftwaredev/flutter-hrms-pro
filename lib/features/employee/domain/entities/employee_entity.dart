import 'package:flutter/foundation.dart';

@immutable
class EmployeeEntity {
  const EmployeeEntity({
    required this.id,

    // =============================================================
    // COMPANY / ORGANIZATION
    // =============================================================
    this.companyId,
    this.departmentId,
    this.designationId,
    this.shiftId,
    this.roleId,

    // =============================================================
    // EMPLOYEE IDENTIFICATION
    // =============================================================
    this.cardNo,

    // =============================================================
    // BASIC INFORMATION
    // =============================================================
    required this.fullName,

    this.gender,
    this.dateOfBirth,

    // =============================================================
    // PERSONAL INFORMATION
    // =============================================================
    this.bloodGroup,
    this.religion,
    this.nationality,
    this.maritalStatus,

    // =============================================================
    // CONTACT INFORMATION
    // =============================================================
    this.mobile,
    this.email,

    this.emergencyContactName,
    this.emergencyContactMobile,

    // =============================================================
    // ADDRESS
    // =============================================================
    this.presentAddress,
    this.permanentAddress,

    // =============================================================
    // EMPLOYMENT INFORMATION
    // =============================================================
    this.joiningDate,
    this.confirmationDate,

    this.employmentType,
    this.employeeStatus,

    // =============================================================
    // IDENTIFICATION DOCUMENTS
    // =============================================================
    this.nidNo,
    this.passportNo,

    // =============================================================
    // SALARY
    // =============================================================
    this.basicSalary = 0,

    // =============================================================
    // MEDIA
    // =============================================================
    this.photoUrl,
    this.signatureUrl,

    // =============================================================
    // STATUS
    // =============================================================
    this.isActive = true,

    // =============================================================
    // AUDIT
    // =============================================================
    this.createdAt,
    this.updatedAt,

    // =============================================================
    // AUTH USER
    // =============================================================
    this.userId,

    // =============================================================
    // CREATED / UPDATED BY
    // =============================================================
    this.createdBy,
    this.updatedBy,

    // =============================================================
    // LAST LOGIN
    // =============================================================
    this.lastLoginAt
  });

  // =============================================================
  // PRIMARY KEY
  // =============================================================

  final String id;

  // =============================================================
  // COMPANY / ORGANIZATION
  // =============================================================

  final String? companyId;
  final String? departmentId;
  final String? designationId;
  final String? shiftId;
  final String? roleId;

  // =============================================================
  // EMPLOYEE IDENTIFICATION
  // =============================================================

  final String? cardNo;

  // =============================================================
  // BASIC INFORMATION
  // =============================================================

  final String fullName;

  final String? gender;
  final DateTime? dateOfBirth;

  // =============================================================
  // PERSONAL INFORMATION
  // =============================================================

  final String? bloodGroup;
  final String? religion;
  final String? nationality;
  final String? maritalStatus;

  // =============================================================
  // CONTACT INFORMATION
  // =============================================================

  final String? mobile;
  final String? email;

  final String? emergencyContactName;
  final String? emergencyContactMobile;

  // =============================================================
  // ADDRESS
  // =============================================================

  final String? presentAddress;
  final String? permanentAddress;

  // =============================================================
  // EMPLOYMENT INFORMATION
  // =============================================================

  final DateTime? joiningDate;
  final DateTime? confirmationDate;

  final String? employmentType;
  final String? employeeStatus;

  // =============================================================
  // IDENTIFICATION DOCUMENTS
  // =============================================================

  final String? nidNo;
  final String? passportNo;

  // =============================================================
  // SALARY
  // =============================================================

  final double basicSalary;

  // =============================================================
  // MEDIA
  // =============================================================

  final String? photoUrl;
  final String? signatureUrl;

  // =============================================================
  // STATUS
  // =============================================================

  final bool isActive;

  // =============================================================
  // AUDIT
  // =============================================================

  final DateTime? createdAt;
  final DateTime? updatedAt;

  // =============================================================
  // AUTH USER
  // =============================================================

  final String? userId;

  // =============================================================
  // CREATED / UPDATED BY
  // =============================================================

  final String? createdBy;
  final String? updatedBy;

  // =============================================================
  // LAST LOGIN
  // =============================================================

  final DateTime? lastLoginAt;

  // =============================================================
  // COPY WITH
  // =============================================================

  EmployeeEntity copyWith({
    String? id,

    // -------------------------------------------------------------
    // COMPANY / ORGANIZATION
    // -------------------------------------------------------------
    String? companyId,
    String? departmentId,
    String? designationId,
    String? shiftId,
    String? roleId,

    // -------------------------------------------------------------
    // EMPLOYEE IDENTIFICATION
    // -------------------------------------------------------------
    String? cardNo,

    // -------------------------------------------------------------
    // BASIC INFORMATION
    // -------------------------------------------------------------
    String? fullName,

    String? gender,
    DateTime? dateOfBirth,

    // -------------------------------------------------------------
    // PERSONAL INFORMATION
    // -------------------------------------------------------------
    String? bloodGroup,
    String? religion,
    String? nationality,
    String? maritalStatus,

    // -------------------------------------------------------------
    // CONTACT INFORMATION
    // -------------------------------------------------------------
    String? mobile,
    String? email,

    String? emergencyContactName,
    String? emergencyContactMobile,

    // -------------------------------------------------------------
    // ADDRESS
    // -------------------------------------------------------------
    String? presentAddress,
    String? permanentAddress,

    // -------------------------------------------------------------
    // EMPLOYMENT INFORMATION
    // -------------------------------------------------------------
    DateTime? joiningDate,
    DateTime? confirmationDate,

    String? employmentType,
    String? employeeStatus,

    // -------------------------------------------------------------
    // IDENTIFICATION DOCUMENTS
    // -------------------------------------------------------------
    String? nidNo,
    String? passportNo,

    // -------------------------------------------------------------
    // SALARY
    // -------------------------------------------------------------
    double? basicSalary,

    // -------------------------------------------------------------
    // MEDIA
    // -------------------------------------------------------------
    String? photoUrl,
    String? signatureUrl,

    // -------------------------------------------------------------
    // STATUS
    // -------------------------------------------------------------
    bool? isActive,

    // -------------------------------------------------------------
    // AUDIT
    // -------------------------------------------------------------
    DateTime? createdAt,
    DateTime? updatedAt,

    // -------------------------------------------------------------
    // AUTH USER
    // -------------------------------------------------------------
    String? userId,

    // -------------------------------------------------------------
    // CREATED / UPDATED BY
    // -------------------------------------------------------------
    String? createdBy,
    String? updatedBy,

    // -------------------------------------------------------------
    // LAST LOGIN
    // -------------------------------------------------------------
    DateTime? lastLoginAt,
  }) {
    return EmployeeEntity(
      id: id ?? this.id,

      // ===========================================================
      // COMPANY / ORGANIZATION
      // ===========================================================
      companyId: companyId ?? this.companyId,
      departmentId: departmentId ?? this.departmentId,
      designationId: designationId ?? this.designationId,
      shiftId: shiftId ?? this.shiftId,
      roleId: roleId ?? this.roleId,

      // ===========================================================
      // EMPLOYEE IDENTIFICATION
      // ===========================================================
      cardNo: cardNo ?? this.cardNo,

      // ===========================================================
      // BASIC INFORMATION
      // ===========================================================
      fullName: fullName ?? this.fullName,

      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,

      // ===========================================================
      // PERSONAL INFORMATION
      // ===========================================================
      bloodGroup: bloodGroup ?? this.bloodGroup,

      religion: religion ?? this.religion,

      nationality: nationality ?? this.nationality,

      maritalStatus: maritalStatus ?? this.maritalStatus,

      // ===========================================================
      // CONTACT INFORMATION
      // ===========================================================
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,

      emergencyContactName: emergencyContactName ?? this.emergencyContactName,

      emergencyContactMobile:
          emergencyContactMobile ?? this.emergencyContactMobile,

      // ===========================================================
      // ADDRESS
      // ===========================================================
      presentAddress: presentAddress ?? this.presentAddress,

      permanentAddress: permanentAddress ?? this.permanentAddress,

      // ===========================================================
      // EMPLOYMENT INFORMATION
      // ===========================================================
      joiningDate: joiningDate ?? this.joiningDate,

      confirmationDate: confirmationDate ?? this.confirmationDate,

      employmentType: employmentType ?? this.employmentType,

      employeeStatus: employeeStatus ?? this.employeeStatus,

      // ===========================================================
      // IDENTIFICATION DOCUMENTS
      // ===========================================================
      nidNo: nidNo ?? this.nidNo,

      passportNo: passportNo ?? this.passportNo,

      // ===========================================================
      // SALARY
      // ===========================================================
      basicSalary: basicSalary ?? this.basicSalary,

      // ===========================================================
      // MEDIA
      // ===========================================================
      photoUrl: photoUrl ?? this.photoUrl,

      signatureUrl: signatureUrl ?? this.signatureUrl,

      // ===========================================================
      // STATUS
      // ===========================================================
      isActive: isActive ?? this.isActive,

      // ===========================================================
      // AUDIT
      // ===========================================================
      createdAt: createdAt ?? this.createdAt,

      updatedAt: updatedAt ?? this.updatedAt,

      // ===========================================================
      // AUTH USER
      // ===========================================================
      userId: userId ?? this.userId,

      // ===========================================================
      // CREATED / UPDATED BY
      // ===========================================================
      createdBy: createdBy ?? this.createdBy,

      updatedBy: updatedBy ?? this.updatedBy,

      // ===========================================================
      // LAST LOGIN
      // ===========================================================
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  // =============================================================
  // EQUALITY
  // =============================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EmployeeEntity &&
            runtimeType == other.runtimeType &&
            id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  // =============================================================
  // TO STRING
  // =============================================================

  @override
  String toString() {
    return 'EmployeeEntity('
        'id: $id, '
        'companyId: $companyId, '
        'fullName: $fullName, '
        'roleId: $roleId, '
        'createdBy: $createdBy, '
        'updatedBy: $updatedBy'
        ')';
  }
}
