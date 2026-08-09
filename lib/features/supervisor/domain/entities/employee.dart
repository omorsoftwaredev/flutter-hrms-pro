/// ===============================================================
/// Flutter HRMS Pro
/// Employee Entity
///
/// Version : 1.0.0
/// ===============================================================

class Employee {
  // =============================================================
  // BASIC
  // =============================================================

  final String id;

  final String? companyId;

  final String? departmentId;

  final String? designationId;

  final String? shiftId;

  final String employeeCode;

  final String? cardNo;

  final String firstName;

  final String? lastName;

  final String fullName;

  // =============================================================
  // PERSONAL INFORMATION
  // =============================================================

  final String? gender;

  final DateTime? dateOfBirth;

  final String? bloodGroup;

  final String? religion;

  final String? nationality;

  final String? maritalStatus;

  // =============================================================
  // CONTACT
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
  // EMPLOYMENT
  // =============================================================

  final DateTime? joiningDate;

  final DateTime? confirmationDate;

  final String? employmentType;

  final String? employeeStatus;

  // =============================================================
  // DOCUMENT
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
  // AUTH
  // =============================================================

  final String? authUserId;

  // =============================================================
  // AUDIT
  // =============================================================

  final String? createdBy;

  final String? updatedBy;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  final DateTime? lastLoginAt;

  // =============================================================
  // ROLE
  // =============================================================

  final String? roleId;

  // =============================================================
  // CONSTRUCTOR
  // =============================================================

  const Employee({
    required this.id,
    this.companyId,
    this.departmentId,
    this.designationId,
    this.shiftId,
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
    this.authUserId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.roleId,
  });

  // =============================================================
  // FROM MAP
  // =============================================================

  factory Employee.fromMap(
      Map<String, dynamic> map,
      ) {
    return Employee(
      id: map['id']?.toString() ?? '',
      companyId:
      map['company_id']?.toString(),
      departmentId:
      map['department_id']?.toString(),
      designationId:
      map['designation_id']?.toString(),
      shiftId:
      map['shift_id']?.toString(),

      employeeCode:
      map['employee_code']?.toString() ?? '',

      cardNo:
      map['card_no']?.toString(),

      firstName:
      map['first_name']?.toString() ?? '',

      lastName:
      map['last_name']?.toString(),

      fullName:
      map['full_name']?.toString() ?? '',

      gender:
      map['gender']?.toString(),

      dateOfBirth:
      _parseDate(map['date_of_birth']),

      bloodGroup:
      map['blood_group']?.toString(),

      religion:
      map['religion']?.toString(),

      nationality:
      map['nationality']?.toString(),

      maritalStatus:
      map['marital_status']?.toString(),

      mobile:
      map['mobile']?.toString(),

      email:
      map['email']?.toString(),

      emergencyContactName:
      map['emergency_contact_name']?.toString(),

      emergencyContactMobile:
      map['emergency_contact_mobile']?.toString(),

      presentAddress:
      map['present_address']?.toString(),

      permanentAddress:
      map['permanent_address']?.toString(),

      joiningDate:
      _parseDate(map['joining_date']),

      confirmationDate:
      _parseDate(map['confirmation_date']),

      employmentType:
      map['employment_type']?.toString(),

      employeeStatus:
      map['employee_status']?.toString(),

      nidNo:
      map['nid_no']?.toString(),

      passportNo:
      map['passport_no']?.toString(),

      basicSalary:
      _parseDouble(map['basic_salary']),

      photoUrl:
      map['photo_url']?.toString(),

      signatureUrl:
      map['signature_url']?.toString(),

      isActive:
      map['is_active'] as bool? ?? true,

      authUserId:
      map['auth_user_id']?.toString(),

      createdBy:
      map['created_by']?.toString(),

      updatedBy:
      map['updated_by']?.toString(),

      createdAt:
      _parseDateTime(map['created_at']),

      updatedAt:
      _parseDateTime(map['updated_at']),

      lastLoginAt:
      _parseDateTime(map['last_login_at']),

      roleId:
      map['role_id']?.toString(),
    );
  }

  // =============================================================
  // TO MAP
  // =============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'department_id': departmentId,
      'designation_id': designationId,
      'shift_id': shiftId,
      'employee_code': employeeCode,
      'card_no': cardNo,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'gender': gender,
      'date_of_birth':
      dateOfBirth?.toIso8601String(),
      'blood_group': bloodGroup,
      'religion': religion,
      'nationality': nationality,
      'marital_status': maritalStatus,
      'mobile': mobile,
      'email': email,
      'emergency_contact_name':
      emergencyContactName,
      'emergency_contact_mobile':
      emergencyContactMobile,
      'present_address': presentAddress,
      'permanent_address':
      permanentAddress,
      'joining_date':
      joiningDate?.toIso8601String(),
      'confirmation_date':
      confirmationDate?.toIso8601String(),
      'employment_type':
      employmentType,
      'employee_status':
      employeeStatus,
      'nid_no': nidNo,
      'passport_no': passportNo,
      'basic_salary': basicSalary,
      'photo_url': photoUrl,
      'signature_url': signatureUrl,
      'is_active': isActive,
      'auth_user_id': authUserId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at':
      createdAt?.toIso8601String(),
      'updated_at':
      updatedAt?.toIso8601String(),
      'last_login_at':
      lastLoginAt?.toIso8601String(),
      'role_id': roleId,
    };
  }

  // =============================================================
  // DISPLAY HELPERS
  // =============================================================

  String get displayName {
    if (fullName.trim().isNotEmpty) {
      return fullName;
    }

    final name = [
      firstName,
      lastName ?? '',
    ].join(' ').trim();

    return name.isEmpty ? employeeCode : name;
  }

  String get displayCode {
    return employeeCode.trim().isEmpty
        ? '-'
        : employeeCode;
  }

  // =============================================================
  // COPY WITH
  // =============================================================

  Employee copyWith({
    String? id,
    String? companyId,
    String? departmentId,
    String? designationId,
    String? shiftId,
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
    String? authUserId,
    String? createdBy,
    String? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    String? roleId,
  }) {
    return Employee(
      id: id ?? this.id,
      companyId:
      companyId ?? this.companyId,
      departmentId:
      departmentId ?? this.departmentId,
      designationId:
      designationId ?? this.designationId,
      shiftId:
      shiftId ?? this.shiftId,
      employeeCode:
      employeeCode ?? this.employeeCode,
      cardNo:
      cardNo ?? this.cardNo,
      firstName:
      firstName ?? this.firstName,
      lastName:
      lastName ?? this.lastName,
      fullName:
      fullName ?? this.fullName,
      gender:
      gender ?? this.gender,
      dateOfBirth:
      dateOfBirth ?? this.dateOfBirth,
      bloodGroup:
      bloodGroup ?? this.bloodGroup,
      religion:
      religion ?? this.religion,
      nationality:
      nationality ?? this.nationality,
      maritalStatus:
      maritalStatus ?? this.maritalStatus,
      mobile:
      mobile ?? this.mobile,
      email:
      email ?? this.email,
      emergencyContactName:
      emergencyContactName ??
          this.emergencyContactName,
      emergencyContactMobile:
      emergencyContactMobile ??
          this.emergencyContactMobile,
      presentAddress:
      presentAddress ?? this.presentAddress,
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
      nidNo:
      nidNo ?? this.nidNo,
      passportNo:
      passportNo ?? this.passportNo,
      basicSalary:
      basicSalary ?? this.basicSalary,
      photoUrl:
      photoUrl ?? this.photoUrl,
      signatureUrl:
      signatureUrl ?? this.signatureUrl,
      isActive:
      isActive ?? this.isActive,
      authUserId:
      authUserId ?? this.authUserId,
      createdBy:
      createdBy ?? this.createdBy,
      updatedBy:
      updatedBy ?? this.updatedBy,
      createdAt:
      createdAt ?? this.createdAt,
      updatedAt:
      updatedAt ?? this.updatedAt,
      lastLoginAt:
      lastLoginAt ?? this.lastLoginAt,
      roleId:
      roleId ?? this.roleId,
    );
  }

  // =============================================================
  // PARSERS
  // =============================================================

  static DateTime? _parseDate(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }

  static DateTime? _parseDateTime(
      dynamic value,
      ) {
    return _parseDate(value);
  }

  static double _parseDouble(
      dynamic value,
      ) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0;
  }

  // =============================================================
  // TO STRING
  // =============================================================

  @override
  String toString() {
    return '''
Employee(
  id: $id,
  employeeCode: $employeeCode,
  fullName: $fullName,
  companyId: $companyId,
  departmentId: $departmentId,
  designationId: $designationId,
  isActive: $isActive,
)
''';
  }
}