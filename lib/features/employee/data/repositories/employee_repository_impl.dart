import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl
    implements EmployeeRepository {
  EmployeeRepositoryImpl(this._ref);

  final Ref _ref;

  final SupabaseClient _client =
      Supabase.instance.client;

  // =============================================================
  // CURRENT USER ID
  // =============================================================

  String get _currentUserId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception(
        'Current user information is not available.',
      );
    }

    final userId = user.userId.trim();

    if (userId.isEmpty) {
      throw Exception(
        'Current user ID is not available.',
      );
    }

    return userId;
  }
  @override
  Future<void> updateEmployeeStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _client
          .from('employees')
          .update({
        'is_active': isActive,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', id);
    } catch (e) {
      throw Exception(
        'Failed to update employee status: $e',
      );
    }
  }
  // =============================================================
  // CURRENT COMPANY ID
  // =============================================================

  String get _currentCompanyId {
    final user = _ref.read(currentUserProvider);

    if (user == null) {
      throw Exception(
        'Current user information is not available.',
      );
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      throw Exception(
        'Company information is not available for this account.',
      );
    }

    return companyId;
  }

  // =============================================================
  // GET EMPLOYEES
  // =============================================================
  //
  // শুধু CurrentUser.companyId-এর employees আসবে।
  //
  // employees.company_id
  //        ==
  // CurrentUser.companyId
  //
  // employee_code অনুযায়ী ascending order হবে।
  //
  // =============================================================

  @override
  Future<List<EmployeeEntity>>
  getEmployees() async {
    try {
      final companyId = _currentCompanyId;

      debugPrint(
        'Employee List Company ID => $companyId',
      );

      final response = await _client
          .from('employees')
          .select()
          .eq(
        'company_id',
        companyId,
      )
          .order(
        'employee_code',
        ascending: true,
      );

      final employees = (response as List)
          .map(
            (json) => EmployeeModel.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .toList();

      debugPrint(
        'Employee List Count => ${employees.length}',
      );

      return employees;
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Employees Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Employees Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // GET EMPLOYEE BY ID
  // =============================================================
  //
  // ID + CurrentUser.companyId
  //
  // অন্য company-এর employee access করা যাবে না।
  //
  // =============================================================

  @override
  Future<EmployeeEntity>
  getEmployeeById(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final employeeId = id.trim();

      if (employeeId.isEmpty) {
        throw Exception(
          'Employee ID is required.',
        );
      }

      final response = await _client
          .from('employees')
          .select()
          .eq(
        'id',
        employeeId,
      )
          .eq(
        'company_id',
        companyId,
      )
          .single();

      return EmployeeModel.fromJson(
        response as Map<String, dynamic>,
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Get Employee Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Get Employee Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // CREATE EMPLOYEE
  // =============================================================
  //
  // company_id:
  //     CurrentUser.companyId
  //
  // created_by:
  //     CurrentUser.userId
  //
  // employee_code:
  //     Database trigger generate করবে।
  //
  // =============================================================

  @override
  Future<void> createEmployee(
      EmployeeEntity employee,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      debugPrint(
        'CREATE EMPLOYEE',
      );

      debugPrint(
        'Company ID => $companyId',
      );

      debugPrint(
        'Created By => $userId',
      );

      await _client
          .from('employees')
          .insert({
        // =======================================================
        // COMPANY
        // =======================================================

        'company_id': companyId,

        // =======================================================
        // ORGANIZATION
        // =======================================================

        'department_id':
        employee.departmentId,

        'designation_id':
        employee.designationId,

        'shift_id':
        employee.shiftId,

        'role_id':
        employee.roleId,

        // =======================================================
        // EMPLOYEE IDENTIFICATION
        // =======================================================
        //
        // employee_code manually পাঠানো হচ্ছে না।
        //
        // Database trigger generate করবে।
        //
        // =======================================================

        'card_no':
        employee.cardNo,

        // =======================================================
        // BASIC INFORMATION
        // =======================================================

        'full_name':
        employee.fullName.trim(),

        'gender':
        employee.gender,

        'date_of_birth':
        employee.dateOfBirth
            ?.toIso8601String()
            .split('T')
            .first,

        // =======================================================
        // PERSONAL INFORMATION
        // =======================================================

        'blood_group':
        employee.bloodGroup,

        'religion':
        employee.religion,

        'nationality':
        employee.nationality,

        'marital_status':
        employee.maritalStatus,

        // =======================================================
        // CONTACT
        // =======================================================

        'mobile':
        employee.mobile,

        'email':
        employee.email,

        'emergency_contact_name':
        employee.emergencyContactName,

        'emergency_contact_mobile':
        employee.emergencyContactMobile,

        // =======================================================
        // ADDRESS
        // =======================================================

        'present_address':
        employee.presentAddress,

        'permanent_address':
        employee.permanentAddress,

        // =======================================================
        // EMPLOYMENT
        // =======================================================

        'joining_date':
        employee.joiningDate
            ?.toIso8601String()
            .split('T')
            .first,

        'confirmation_date':
        employee.confirmationDate
            ?.toIso8601String()
            .split('T')
            .first,

        'employment_type':
        employee.employmentType,

        'employee_status':
        employee.employeeStatus,

        // =======================================================
        // DOCUMENTS
        // =======================================================

        'nid_no':
        employee.nidNo,

        'passport_no':
        employee.passportNo,

        // =======================================================
        // SALARY
        // =======================================================

        'basic_salary':
        employee.basicSalary,

        // =======================================================
        // MEDIA
        // =======================================================

        'photo_url':
        employee.photoUrl,

        'signature_url':
        employee.signatureUrl,

        // =======================================================
        // STATUS
        // =======================================================

        'is_active':
        employee.isActive,

        // =======================================================
        // AUTH USER
        // =======================================================

        'auth_user_id':
        employee.userId,

        // =======================================================
        // AUDIT
        // =======================================================

        'created_by':
        userId,

        // নতুন employee create করার সময়
        // updated_by manually দেওয়া হচ্ছে না।

        // =======================================================
        // LAST LOGIN
        // =======================================================

        'last_login_at':
        employee.lastLoginAt
            ?.toIso8601String(),
      });

      debugPrint(
        'Employee Created Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Create Employee Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Create Employee Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // UPDATE EMPLOYEE
  // =============================================================
  //
  // Employee ID + CurrentUser.companyId
  //
  // অন্য company-এর employee update করা যাবে না।
  //
  // created_by কখনো update হবে না।
  //
  // updated_by = CurrentUser.userId
  //
  // employee_code update করা যাবে না।
  //
  // =============================================================

  @override
  Future<void> updateEmployee(
      EmployeeEntity employee,
      ) async {
    try {
      final companyId = _currentCompanyId;
      final userId = _currentUserId;

      final employeeId =
      employee.id.trim();

      if (employeeId.isEmpty) {
        throw Exception(
          'Employee ID is required for update.',
        );
      }

      debugPrint(
        'UPDATE EMPLOYEE',
      );

      debugPrint(
        'Employee ID => $employeeId',
      );

      debugPrint(
        'Company ID => $companyId',
      );

      debugPrint(
        'Updated By => $userId',
      );

      final response = await _client
          .from('employees')
          .update({
        // =======================================================
        // ORGANIZATION
        // =======================================================

        'department_id':
        employee.departmentId,

        'designation_id':
        employee.designationId,

        'shift_id':
        employee.shiftId,

        'role_id':
        employee.roleId,

        // =======================================================
        // EMPLOYEE IDENTIFICATION
        // =======================================================
        //
        // employee_code update করা হচ্ছে না।
        //
        // =======================================================

        'card_no':
        employee.cardNo,

        // =======================================================
        // BASIC INFORMATION
        // =======================================================

        'full_name':
        employee.fullName.trim(),

        'gender':
        employee.gender,

        'date_of_birth':
        employee.dateOfBirth
            ?.toIso8601String()
            .split('T')
            .first,

        // =======================================================
        // PERSONAL INFORMATION
        // =======================================================

        'blood_group':
        employee.bloodGroup,

        'religion':
        employee.religion,

        'nationality':
        employee.nationality,

        'marital_status':
        employee.maritalStatus,

        // =======================================================
        // CONTACT
        // =======================================================

        'mobile':
        employee.mobile,

        'email':
        employee.email,

        'emergency_contact_name':
        employee.emergencyContactName,

        'emergency_contact_mobile':
        employee.emergencyContactMobile,

        // =======================================================
        // ADDRESS
        // =======================================================

        'present_address':
        employee.presentAddress,

        'permanent_address':
        employee.permanentAddress,

        // =======================================================
        // EMPLOYMENT
        // =======================================================

        'joining_date':
        employee.joiningDate
            ?.toIso8601String()
            .split('T')
            .first,

        'confirmation_date':
        employee.confirmationDate
            ?.toIso8601String()
            .split('T')
            .first,

        'employment_type':
        employee.employmentType,

        'employee_status':
        employee.employeeStatus,

        // =======================================================
        // DOCUMENTS
        // =======================================================

        'nid_no':
        employee.nidNo,

        'passport_no':
        employee.passportNo,

        // =======================================================
        // SALARY
        // =======================================================

        'basic_salary':
        employee.basicSalary,

        // =======================================================
        // MEDIA
        // =======================================================

        'photo_url':
        employee.photoUrl,

        'signature_url':
        employee.signatureUrl,

        // =======================================================
        // STATUS
        // =======================================================

        'is_active':
        employee.isActive,

        // =======================================================
        // AUTH USER
        // =======================================================

        'auth_user_id':
        employee.userId,

        // =======================================================
        // UPDATED BY
        // =======================================================

        'updated_by':
        userId,

        // =======================================================
        // LAST LOGIN
        // =======================================================

        'last_login_at':
        employee.lastLoginAt
            ?.toIso8601String(),
      })
          .eq(
        'id',
        employeeId,
      )
          .eq(
        'company_id',
        companyId,
      )
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Employee not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Employee Updated Successfully.',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Update Employee Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Update Employee Error: $e',
      );

      rethrow;
    }
  }

  // =============================================================
  // DELETE EMPLOYEE
  // =============================================================
  //
  // ID + CurrentUser.companyId
  //
  // অন্য company-এর employee delete করা যাবে না।
  //
  // =============================================================

  @override
  Future<void> deleteEmployee(
      String id,
      ) async {
    try {
      final companyId = _currentCompanyId;

      final employeeId = id.trim();

      if (employeeId.isEmpty) {
        throw Exception(
          'Employee ID is required.',
        );
      }

      final response = await _client
          .from('employees')
          .delete()
          .eq(
        'id',
        employeeId,
      )
          .eq(
        'company_id',
        companyId,
      )
          .select();

      if ((response as List).isEmpty) {
        throw Exception(
          'Employee not found or does not belong to the current company.',
        );
      }

      debugPrint(
        'Employee Deleted => $employeeId',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'Delete Employee Postgrest Error: ${e.message}',
      );

      throw Exception(e.message);
    } catch (e) {
      debugPrint(
        'Delete Employee Error: $e',
      );

      rethrow;
    }
  }
}