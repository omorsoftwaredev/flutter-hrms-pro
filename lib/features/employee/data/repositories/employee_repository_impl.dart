import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl
    implements EmployeeRepository {
  EmployeeRepositoryImpl();

  final SupabaseClient _client =
      Supabase.instance.client;

  @override
  Future<List<EmployeeEntity>>
  getEmployees() async {
    final response = await _client
        .from('employees')
        .select()
        .order(
      'employee_code',
      ascending: true,
    );

    return (response as List)
        .map(
          (e) => EmployeeModel.fromJson(
        e as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  @override
  Future<EmployeeEntity>
  getEmployeeById(
      String id,
      ) async {
    final response = await _client
        .from('employees')
        .select()
        .eq('id', id)
        .single();

    return EmployeeModel.fromJson(
      response,
    );
  }

  @override
  Future<void> createEmployee(
      EmployeeEntity employee,
      ) async {
    await _client
        .from('employees')
        .insert({
      'company_id': employee.companyId,
      'department_id':
      employee.departmentId,
      'designation_id':
      employee.designationId,
      'shift_id': employee.shiftId,

      'employee_code':
      employee.employeeCode,
      'card_no': employee.cardNo,

      'first_name':
      employee.firstName,
      'last_name':
      employee.lastName,
      'full_name':
      employee.fullName,

      'gender': employee.gender,

      'date_of_birth':
      employee.dateOfBirth
          ?.toIso8601String()
          .split('T')
          .first,

      'blood_group':
      employee.bloodGroup,

      'religion':
      employee.religion,

      'nationality':
      employee.nationality,

      'marital_status':
      employee.maritalStatus,

      'mobile':
      employee.mobile,

      'email':
      employee.email,

      'emergency_contact_name':
      employee
          .emergencyContactName,

      'emergency_contact_mobile':
      employee
          .emergencyContactMobile,

      'present_address':
      employee.presentAddress,

      'permanent_address':
      employee.permanentAddress,

      'joining_date':
      employee.joiningDate
          ?.toIso8601String()
          .split('T')
          .first,

      'confirmation_date':
      employee
          .confirmationDate
          ?.toIso8601String()
          .split('T')
          .first,

      'employment_type':
      employee.employmentType,

      'employee_status':
      employee.employeeStatus,

      'nid_no':
      employee.nidNo,

      'passport_no':
      employee.passportNo,

      'basic_salary':
      employee.basicSalary,

      'photo_url':
      employee.photoUrl,

      'signature_url':
      employee.signatureUrl,

      'is_active':
      employee.isActive,

      'auth_user_id': employee.userId,

      'role_id': employee.roleId,

      'created_by':
      employee.createdBy,

      'updated_by':
      employee.updatedBy,

      'last_login_at':
      employee.lastLoginAt
          ?.toIso8601String(),
    });
  }

  @override
  Future<void> updateEmployee(
      EmployeeEntity employee,
      ) async {
    await _client
        .from('employees')
        .update({
      'company_id': employee.companyId,
      'department_id':
      employee.departmentId,
      'designation_id':
      employee.designationId,
      'shift_id': employee.shiftId,

      'employee_code':
      employee.employeeCode,
      'card_no': employee.cardNo,

      'first_name':
      employee.firstName,
      'last_name':
      employee.lastName,
      'full_name':
      employee.fullName,

      'gender': employee.gender,

      'date_of_birth':
      employee.dateOfBirth
          ?.toIso8601String()
          .split('T')
          .first,

      'blood_group':
      employee.bloodGroup,

      'religion':
      employee.religion,

      'nationality':
      employee.nationality,

      'marital_status':
      employee.maritalStatus,

      'mobile':
      employee.mobile,

      'email':
      employee.email,

      'emergency_contact_name':
      employee
          .emergencyContactName,

      'emergency_contact_mobile':
      employee
          .emergencyContactMobile,

      'present_address':
      employee.presentAddress,

      'permanent_address':
      employee.permanentAddress,

      'joining_date':
      employee.joiningDate
          ?.toIso8601String()
          .split('T')
          .first,

      'confirmation_date':
      employee
          .confirmationDate
          ?.toIso8601String()
          .split('T')
          .first,

      'employment_type':
      employee.employmentType,

      'employee_status':
      employee.employeeStatus,

      'nid_no':
      employee.nidNo,

      'passport_no':
      employee.passportNo,

      'basic_salary':
      employee.basicSalary,

      'photo_url':
      employee.photoUrl,

      'signature_url':
      employee.signatureUrl,

      'is_active':
      employee.isActive,

      'auth_user_id': employee.userId,

      'role_id': employee.roleId,

      'created_by':
      employee.createdBy,

      'updated_by':
      employee.updatedBy,

      'last_login_at':
      employee.lastLoginAt
          ?.toIso8601String(),
    }).eq(
      'id',
      employee.id,
    );
  }

  @override
  Future<void> deleteEmployee(
      String id,
      ) async {
    await _client
        .from('employees')
        .delete()
        .eq(
      'id',
      id,
    );
  }
}