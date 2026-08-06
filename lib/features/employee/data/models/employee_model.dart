import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,

    super.companyId,
    super.departmentId,
    super.designationId,
    super.shiftId,
    super.roleId,

    required super.employeeCode,
    super.cardNo,

    required super.firstName,
    super.lastName,
    required super.fullName,

    super.gender,
    super.dateOfBirth,

    super.bloodGroup,
    super.religion,
    super.nationality,
    super.maritalStatus,

    super.mobile,
    super.email,

    super.emergencyContactName,
    super.emergencyContactMobile,

    super.presentAddress,
    super.permanentAddress,

    super.joiningDate,
    super.confirmationDate,

    super.employmentType,
    super.employeeStatus,

    super.nidNo,
    super.passportNo,

    super.basicSalary,

    super.photoUrl,
    super.signatureUrl,

    super.isActive,

    super.createdAt,
    super.updatedAt,

    super.userId,

    super.createdBy,
    super.updatedBy,

    super.lastLoginAt,
  });

  factory EmployeeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return EmployeeModel(
      id: json['id'] ?? '',

      companyId: json['company_id'],
      departmentId: json['department_id'],
      designationId: json['designation_id'],
      shiftId: json['shift_id'],
      roleId: json['role_id'],

      employeeCode: json['employee_code'] ?? '',
      cardNo: json['card_no'],

      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],

      fullName: json['full_name'] ?? '',

      gender: json['gender'],

      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(
        json['date_of_birth'],
      ),

      bloodGroup: json['blood_group'],
      religion: json['religion'],
      nationality: json['nationality'],
      maritalStatus: json['marital_status'],

      mobile: json['mobile'],
      email: json['email'],

      emergencyContactName:
      json['emergency_contact_name'],

      emergencyContactMobile:
      json['emergency_contact_mobile'],

      presentAddress:
      json['present_address'],

      permanentAddress:
      json['permanent_address'],

      joiningDate:
      json['joining_date'] == null
          ? null
          : DateTime.parse(
        json['joining_date'],
      ),

      confirmationDate:
      json['confirmation_date'] == null
          ? null
          : DateTime.parse(
        json['confirmation_date'],
      ),

      employmentType:
      json['employment_type'],

      employeeStatus:
      json['employee_status'],

      nidNo: json['nid_no'],
      passportNo:
      json['passport_no'],

      basicSalary:
      (json['basic_salary'] ?? 0)
          .toDouble(),

      photoUrl:
      json['photo_url'],

      signatureUrl:
      json['signature_url'],

      isActive:
      json['is_active'] ?? true,

      createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(
        json['created_at'],
      ),

      updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(
        json['updated_at'],
      ),

      userId:
      json['auth_user_id'],

      createdBy:
      json['created_by'],

      updatedBy:
      json['updated_by'],

      lastLoginAt:
      json['last_login_at'] == null
          ? null
          : DateTime.parse(
        json['last_login_at'],
      ),
    );
  }
  factory EmployeeModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return EmployeeModel.fromJson(map);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'company_id': companyId,
      'department_id': departmentId,
      'designation_id': designationId,
      'shift_id': shiftId,
      'role_id': roleId,

      'employee_code': employeeCode,
      'card_no': cardNo,

      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,

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

      'mobile': mobile,
      'email': email,

      'emergency_contact_name':
      emergencyContactName,

      'emergency_contact_mobile':
      emergencyContactMobile,

      'present_address':
      presentAddress,

      'permanent_address':
      permanentAddress,

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

      'nid_no': nidNo,
      'passport_no': passportNo,

      'basic_salary':
      basicSalary,

      'photo_url':
      photoUrl,

      'signature_url':
      signatureUrl,

      'is_active':
      isActive,

      'created_at':
      createdAt
          ?.toIso8601String(),

      'updated_at':
      updatedAt
          ?.toIso8601String(),

      'auth_user_id':
      userId,

      'created_by':
      createdBy,

      'updated_by':
      updatedBy,

      'last_login_at':
      lastLoginAt
          ?.toIso8601String(),
    };
  }
}