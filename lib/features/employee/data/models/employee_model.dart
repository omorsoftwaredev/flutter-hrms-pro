import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,

    // =========================================================
    // ORGANIZATION
    // =========================================================

    super.companyId,
    super.departmentId,
    super.designationId,
    super.shiftId,
    super.roleId,

    // =========================================================
    // EMPLOYEE CODE / CARD
    // =========================================================

    required super.employeeCode,
    super.cardNo,

    // =========================================================
    // NAME
    // =========================================================

    required super.firstName,
    super.lastName,
    required super.fullName,

    // =========================================================
    // PERSONAL INFORMATION
    // =========================================================

    super.gender,
    super.dateOfBirth,
    super.bloodGroup,
    super.religion,
    super.nationality,
    super.maritalStatus,

    // =========================================================
    // CONTACT
    // =========================================================

    super.mobile,
    super.email,

    // =========================================================
    // EMERGENCY CONTACT
    // =========================================================

    super.emergencyContactName,
    super.emergencyContactMobile,

    // =========================================================
    // ADDRESS
    // =========================================================

    super.presentAddress,
    super.permanentAddress,

    // =========================================================
    // EMPLOYMENT
    // =========================================================

    super.joiningDate,
    super.confirmationDate,
    super.employmentType,
    super.employeeStatus,

    // =========================================================
    // IDENTIFICATION
    // =========================================================

    super.nidNo,
    super.passportNo,

    // =========================================================
    // SALARY
    // =========================================================

    super.basicSalary,

    // =========================================================
    // FILES
    // =========================================================

    super.photoUrl,
    super.signatureUrl,

    // =========================================================
    // STATUS
    // =========================================================

    super.isActive,

    // =========================================================
    // AUDIT
    // =========================================================

    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.updatedBy,

    // =========================================================
    // AUTH
    // =========================================================

    super.userId,
    super.lastLoginAt,
  });

  // =============================================================
  // FROM JSON
  // =============================================================

  factory EmployeeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return EmployeeModel(
      // ---------------------------------------------------------
      // ID
      // ---------------------------------------------------------

      id: json['id']?.toString() ?? '',

      // ---------------------------------------------------------
      // ORGANIZATION
      // ---------------------------------------------------------

      companyId: json['company_id']?.toString(),
      departmentId: json['department_id']?.toString(),
      designationId: json['designation_id']?.toString(),
      shiftId: json['shift_id']?.toString(),
      roleId: json['role_id']?.toString(),

      // ---------------------------------------------------------
      // EMPLOYEE CODE
      // ---------------------------------------------------------

      employeeCode:
      json['employee_code']?.toString() ?? '',

      // ---------------------------------------------------------
      // CARD
      // ---------------------------------------------------------

      cardNo: json['card_no']?.toString(),

      // ---------------------------------------------------------
      // NAME
      // ---------------------------------------------------------

      firstName:
      json['first_name']?.toString() ?? '',

      lastName:
      json['last_name']?.toString(),

      fullName:
      json['full_name']?.toString() ?? '',

      // ---------------------------------------------------------
      // PERSONAL INFORMATION
      // ---------------------------------------------------------

      gender:
      json['gender']?.toString(),

      dateOfBirth:
      json['date_of_birth'] == null
          ? null
          : DateTime.parse(
        json['date_of_birth'].toString(),
      ),

      bloodGroup:
      json['blood_group']?.toString(),

      religion:
      json['religion']?.toString(),

      nationality:
      json['nationality']?.toString(),

      maritalStatus:
      json['marital_status']?.toString(),

      // ---------------------------------------------------------
      // CONTACT
      // ---------------------------------------------------------

      mobile:
      json['mobile']?.toString(),

      email:
      json['email']?.toString(),

      // ---------------------------------------------------------
      // EMERGENCY CONTACT
      // ---------------------------------------------------------

      emergencyContactName:
      json['emergency_contact_name']?.toString(),

      emergencyContactMobile:
      json['emergency_contact_mobile']?.toString(),

      // ---------------------------------------------------------
      // ADDRESS
      // ---------------------------------------------------------

      presentAddress:
      json['present_address']?.toString(),

      permanentAddress:
      json['permanent_address']?.toString(),

      // ---------------------------------------------------------
      // EMPLOYMENT
      // ---------------------------------------------------------

      joiningDate:
      json['joining_date'] == null
          ? null
          : DateTime.parse(
        json['joining_date'].toString(),
      ),

      confirmationDate:
      json['confirmation_date'] == null
          ? null
          : DateTime.parse(
        json['confirmation_date'].toString(),
      ),

      employmentType:
      json['employment_type']?.toString(),

      employeeStatus:
      json['employee_status']?.toString(),

      // ---------------------------------------------------------
      // IDENTIFICATION
      // ---------------------------------------------------------

      nidNo:
      json['nid_no']?.toString(),

      passportNo:
      json['passport_no']?.toString(),

      // ---------------------------------------------------------
      // SALARY
      // ---------------------------------------------------------

      basicSalary:
      json['basic_salary'] == null
          ? null
          : json['basic_salary'],

      // ---------------------------------------------------------
      // FILES
      // ---------------------------------------------------------

      photoUrl:
      json['photo_url']?.toString(),

      signatureUrl:
      json['signature_url']?.toString(),

      // ---------------------------------------------------------
      // STATUS
      // ---------------------------------------------------------

      isActive:
      json['is_active'] ?? true,

      // ---------------------------------------------------------
      // AUDIT
      // ---------------------------------------------------------

      createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(
        json['created_at'].toString(),
      ),

      updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(
        json['updated_at'].toString(),
      ),

      createdBy:
      json['created_by']?.toString(),

      updatedBy:
      json['updated_by']?.toString(),

      // ---------------------------------------------------------
      // AUTH USER
      // ---------------------------------------------------------

      userId:
      json['auth_user_id']?.toString(),

      lastLoginAt:
      json['last_login_at'] == null
          ? null
          : DateTime.parse(
        json['last_login_at'].toString(),
      ),
    );
  }

  // =============================================================
  // FROM MAP
  // =============================================================

  factory EmployeeModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return EmployeeModel.fromJson(map);
  }

  // =============================================================
  // TO JSON
  // =============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      // ---------------------------------------------------------
      // ORGANIZATION
      // ---------------------------------------------------------

      'company_id': companyId,
      'department_id': departmentId,
      'designation_id': designationId,
      'shift_id': shiftId,
      'role_id': roleId,

      // ---------------------------------------------------------
      // EMPLOYEE CODE
      // ---------------------------------------------------------

      'employee_code': employeeCode,

      // ---------------------------------------------------------
      // CARD
      // ---------------------------------------------------------

      'card_no': cardNo,

      // ---------------------------------------------------------
      // NAME
      // ---------------------------------------------------------

      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,

      // ---------------------------------------------------------
      // PERSONAL INFORMATION
      // ---------------------------------------------------------

      'gender': gender,

      'date_of_birth':
      dateOfBirth
          ?.toIso8601String()
          .split('T')
          .first,

      'blood_group': bloodGroup,
      'religion': religion,
      'nationality': nationality,
      'marital_status': maritalStatus,

      // ---------------------------------------------------------
      // CONTACT
      // ---------------------------------------------------------

      'mobile': mobile,
      'email': email,

      // ---------------------------------------------------------
      // EMERGENCY CONTACT
      // ---------------------------------------------------------

      'emergency_contact_name':
      emergencyContactName,

      'emergency_contact_mobile':
      emergencyContactMobile,

      // ---------------------------------------------------------
      // ADDRESS
      // ---------------------------------------------------------

      'present_address':
      presentAddress,

      'permanent_address':
      permanentAddress,

      // ---------------------------------------------------------
      // EMPLOYMENT
      // ---------------------------------------------------------

      'joining_date':
      joiningDate
          ?.toIso8601String()
          .split('T')
          .first,

      'confirmation_date':
      confirmationDate
          ?.toIso8601String()
          .split('T')
          .first,

      'employment_type':
      employmentType,

      'employee_status':
      employeeStatus,

      // ---------------------------------------------------------
      // IDENTIFICATION
      // ---------------------------------------------------------

      'nid_no': nidNo,
      'passport_no': passportNo,

      // ---------------------------------------------------------
      // SALARY
      // ---------------------------------------------------------

      'basic_salary': basicSalary,

      // ---------------------------------------------------------
      // FILES
      // ---------------------------------------------------------

      'photo_url': photoUrl,
      'signature_url': signatureUrl,

      // ---------------------------------------------------------
      // STATUS
      // ---------------------------------------------------------

      'is_active': isActive,

      // ---------------------------------------------------------
      // AUDIT
      // ---------------------------------------------------------

      'created_at':
      createdAt?.toIso8601String(),

      'updated_at':
      updatedAt?.toIso8601String(),

      'created_by': createdBy,
      'updated_by': updatedBy,

      // ---------------------------------------------------------
      // AUTH USER
      // ---------------------------------------------------------

      'auth_user_id': userId,

      'last_login_at':
      lastLoginAt?.toIso8601String(),
    };
  }
}