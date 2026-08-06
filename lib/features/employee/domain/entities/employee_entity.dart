class EmployeeEntity {
  final String id;

  final String? companyId;
  final String? departmentId;
  final String? designationId;
  final String? shiftId;
  final String? roleId;
  final String employeeCode;
  final String? cardNo;

  final String firstName;
  final String? lastName;
  final String fullName;

  final String? gender;
  final DateTime? dateOfBirth;

  final String? bloodGroup;
  final String? religion;
  final String? nationality;
  final String? maritalStatus;

  final String? mobile;
  final String? email;

  final String? emergencyContactName;
  final String? emergencyContactMobile;

  final String? presentAddress;
  final String? permanentAddress;

  final DateTime? joiningDate;
  final DateTime? confirmationDate;

  final String? employmentType;
  final String? employeeStatus;

  final String? nidNo;
  final String? passportNo;

  final double basicSalary;

  final String? photoUrl;
  final String? signatureUrl;

  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? userId;

  final String? createdBy;
  final String? updatedBy;

  final DateTime? lastLoginAt;

  const EmployeeEntity({
    required this.id,

    this.companyId,
    this.departmentId,
    this.designationId,
    this.shiftId,
    this.roleId,

    required this.employeeCode,
    this.cardNo,

    required this.firstName,
    this.lastName,
    required this.fullName,

    this.gender,
    this.dateOfBirth,

    this.bloodGroup,
    this.religion,
    this.nationality,
    this.maritalStatus,

    this.mobile,
    this.email,

    this.emergencyContactName,
    this.emergencyContactMobile,

    this.presentAddress,
    this.permanentAddress,

    this.joiningDate,
    this.confirmationDate,

    this.employmentType,
    this.employeeStatus,

    this.nidNo,
    this.passportNo,

    this.basicSalary = 0,

    this.photoUrl,
    this.signatureUrl,

    this.isActive = true,

    this.createdAt,
    this.updatedAt,

    this.userId,

    this.createdBy,
    this.updatedBy,

    this.lastLoginAt,
  });

  EmployeeEntity copyWith({
    String? id,

    String? companyId,
    String? departmentId,
    String? designationId,
    String? shiftId,
    String? roleId,

    String? employeeCode,
    String? cardNo,

    String? firstName,
    String? lastName,
    String? fullName,

    String? gender,
    DateTime? dateOfBirth,

    String? bloodGroup,
    String? religion,
    String? nationality,
    String? maritalStatus,

    String? mobile,
    String? email,

    String? emergencyContactName,
    String? emergencyContactMobile,

    String? presentAddress,
    String? permanentAddress,

    DateTime? joiningDate,
    DateTime? confirmationDate,

    String? employmentType,
    String? employeeStatus,

    String? nidNo,
    String? passportNo,

    double? basicSalary,

    String? photoUrl,
    String? signatureUrl,

    bool? isActive,

    DateTime? createdAt,
    DateTime? updatedAt,

    String? userId,

    String? role,

    String? createdBy,
    String? updatedBy,

    DateTime? lastLoginAt,
  }) {
    return EmployeeEntity(
      id: id ?? this.id,

      companyId: companyId ?? this.companyId,
      departmentId: departmentId ?? this.departmentId,
      designationId: designationId ?? this.designationId,
      shiftId: shiftId ?? this.shiftId,
      roleId: roleId ?? this.roleId,

      employeeCode:
      employeeCode ?? this.employeeCode,
      cardNo: cardNo ?? this.cardNo,

      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,

      gender: gender ?? this.gender,
      dateOfBirth:
      dateOfBirth ?? this.dateOfBirth,

      bloodGroup:
      bloodGroup ?? this.bloodGroup,
      religion: religion ?? this.religion,
      nationality:
      nationality ?? this.nationality,
      maritalStatus:
      maritalStatus ?? this.maritalStatus,

      mobile: mobile ?? this.mobile,
      email: email ?? this.email,

      emergencyContactName:
      emergencyContactName ??
          this.emergencyContactName,

      emergencyContactMobile:
      emergencyContactMobile ??
          this.emergencyContactMobile,

      presentAddress:
      presentAddress ??
          this.presentAddress,

      permanentAddress:
      permanentAddress ??
          this.permanentAddress,

      joiningDate:
      joiningDate ?? this.joiningDate,

      confirmationDate:
      confirmationDate ??
          this.confirmationDate,

      employmentType:
      employmentType ??
          this.employmentType,

      employeeStatus:
      employeeStatus ??
          this.employeeStatus,

      nidNo: nidNo ?? this.nidNo,
      passportNo:
      passportNo ?? this.passportNo,

      basicSalary:
      basicSalary ?? this.basicSalary,

      photoUrl:
      photoUrl ?? this.photoUrl,

      signatureUrl:
      signatureUrl ??
          this.signatureUrl,

      isActive:
      isActive ?? this.isActive,

      createdAt:
      createdAt ?? this.createdAt,

      updatedAt:
      updatedAt ?? this.updatedAt,

      userId:
      userId ?? this.userId,

      createdBy:
      createdBy ?? this.createdBy,

      updatedBy:
      updatedBy ?? this.updatedBy,

      lastLoginAt:
      lastLoginAt ??
          this.lastLoginAt,
    );
  }
}