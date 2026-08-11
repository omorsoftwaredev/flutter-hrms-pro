/// ===============================================================
/// Flutter HRMS Pro
/// Authentication Repository
///
/// Version : 2.2.0
/// ===============================================================

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';
import 'current_user.dart';
import 'roles.dart';
import 'user_type.dart';

class AuthRepository {
  AuthRepository();

  final SupabaseClient _client = SupabaseService.client;

  // =============================================================
  // Session Key
  // =============================================================

  static const String _sessionKey = 'current_user';

  // =============================================================
  // SAVE SESSION
  // =============================================================

  Future<void> _saveSession(CurrentUser user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _sessionKey,
      jsonEncode({
        // =======================================================
        // Common
        // =======================================================
        'userId': user.userId,
        'loginName': user.loginName,
        'userType': user.userType.name,
        'role': user.role.value,
        'fullName': user.fullName,
        'email': user.email,

        // =======================================================
        // Employee
        // =======================================================
        'employeeId': user.employeeId,
        'employeeCode': user.employeeCode,
        'employeeName': user.employeeName,

        // =======================================================
        // Company
        // =======================================================
        'companyId': user.companyId,
        'companyName': user.companyName,

        // =======================================================
        // Department
        // =======================================================
        'departmentId': user.departmentId,
        'departmentName': user.departmentName,

        // =======================================================
        // Designation
        // =======================================================
        'designationId': user.designationId,
        'designationName': user.designationName,
      }),
    );
  }

  // =============================================================
  // CLEAR SESSION
  // =============================================================

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_sessionKey);
  }

  // =============================================================
  // CHECK SUPERVISOR
  // =============================================================
  //
  // Flow:
  //
  // employee_accounts.employee_id
  //              ↓
  // supervisors.employee_id
  //              ↓
  // supervisors.id
  //              ↓
  // supervisor_departments.supervisor_id
  //
  // Supervisor হতে হলে:
  //
  // 1. supervisors table-এ employee_id থাকতে হবে
  // 2. supervisors.is_active = true হতে হবে
  // 3. supervisor_departments table-এ ওই supervisor-এর
  //    কমপক্ষে একটি department assignment থাকতে হবে
  //
  // =============================================================

  Future<bool> _isActiveSupervisorWithDepartment({
    required String employeeId,
  }) async {
    try {
      // =========================================================
      // Employee ID empty হলে supervisor হওয়ার সুযোগ নেই
      // =========================================================

      if (employeeId.trim().isEmpty) {
        print(
          'SUPERVISOR CHECK => Employee ID is empty',
        );

        return false;
      }

      // =========================================================
      // 1. CHECK SUPERVISORS TABLE
      // =========================================================

      final supervisor = await _client
          .from('supervisors')
          .select(
        'id, employee_id, company_id, department_id, is_active',
      )
          .eq('employee_id', employeeId)
          .eq('is_active', true)
          .maybeSingle();

      print(
        'Supervisor Record => $supervisor',
      );

      // =========================================================
      // Supervisor record পাওয়া যায়নি
      // =========================================================

      if (supervisor == null) {
        print(
          'SUPERVISOR CHECK => No active supervisor record',
        );

        return false;
      }

      // =========================================================
      // Supervisor ID
      // =========================================================

      final supervisorId =
          supervisor['id']?.toString() ?? '';

      if (supervisorId.isEmpty) {
        print(
          'SUPERVISOR CHECK => Supervisor ID is empty',
        );

        return false;
      }

      // =========================================================
      // 2. CHECK SUPERVISOR DEPARTMENTS TABLE
      // =========================================================
      //
      // এখানে employee_id নেই।
      //
      // তাই supervisors.id দিয়ে
      // supervisor_departments.supervisor_id
      // check করতে হবে।
      //
      // একাধিক department থাকতে পারে।
      //
      // তাই maybeSingle() ব্যবহার করছি না।
      //
      // শুধু প্রথম একটি record পেলেই assignment আছে
      // বলে ধরে নিচ্ছি।
      //
      // =========================================================

      final supervisorDepartments = await _client
          .from('supervisor_departments')
          .select('id, supervisor_id, department_id')
          .eq('supervisor_id', supervisorId)
          .limit(1);

      print(
        'Supervisor Department Record => '
            '$supervisorDepartments',
      );

      // =========================================================
      // কোনো department assignment নেই
      // =========================================================

      if (supervisorDepartments.isEmpty) {
        print(
          'SUPERVISOR CHECK => No department assigned',
        );

        return false;
      }

      // =========================================================
      // Supervisor confirmed
      // =========================================================

      print(
        'SUPERVISOR CHECK => ACTIVE SUPERVISOR + '
            'DEPARTMENT ASSIGNED',
      );

      return true;
    } catch (e) {
      // =========================================================
      // Important:
      //
      // Supervisor check fail করলে employee login বন্ধ করব না।
      // Employee dashboard-এ fallback করবে।
      // =========================================================

      print(
        'SUPERVISOR CHECK ERROR => $e',
      );

      return false;
    }
  }

  // =============================================================
  // LOGIN
  // =============================================================

  Future<CurrentUser> login({
    required String username,
    required String passwordHash,
  }) async {
    print('================ LOGIN ================');
    print('Username: $username');

    // ===========================================================
    // 1. DEVELOPER LOGIN
    // ===========================================================

    final developer = await _client
        .from('developers')
        .select()
        .eq('username', username)
        .eq('password_hash', passwordHash)
        .maybeSingle();

    print('Developer => $developer');

    if (developer != null) {
      final user = CurrentUser(
        // -------------------------------------------------------
        // Common
        // -------------------------------------------------------

        userId: developer['id'].toString(),

        loginName:
        developer['username']?.toString() ?? username,

        fullName:
        developer['full_name']?.toString() ?? '',

        email:
        developer['email']?.toString() ?? '',

        userType: UserType.developer,

        role: UserRole.developer,

        // -------------------------------------------------------
        // Employee
        // -------------------------------------------------------

        employeeId: '',
        employeeCode: null,
        employeeName: null,

        // -------------------------------------------------------
        // Company
        // -------------------------------------------------------

        companyId: '',
        companyName: null,

        // -------------------------------------------------------
        // Department
        // -------------------------------------------------------

        departmentId: null,
        departmentName: null,

        // -------------------------------------------------------
        // Designation
        // -------------------------------------------------------

        designationId: null,
        designationName: null,
      );

      await _saveSession(user);

      return user;
    }

    // ===========================================================
    // 2. COMPANY OWNER LOGIN
    // ===========================================================

    final company = await _client
        .from('company_accounts')
        .select()
        .eq('username', username)
        .eq('password_hash', passwordHash)
        .eq('is_active', true)
        .maybeSingle();

    print('Company Account => $company');

    if (company != null) {
      // ---------------------------------------------------------
      // Company ID
      // ---------------------------------------------------------

      final companyId =
          company['company_id']?.toString() ?? '';

      // ---------------------------------------------------------
      // Company Name
      // ---------------------------------------------------------

      String? companyName;

      if (companyId.isNotEmpty) {
        final companyData = await _client
            .from('companies')
            .select('id, name')
            .eq('id', companyId)
            .maybeSingle();

        companyName =
            companyData?['name']?.toString();
      }

      // ---------------------------------------------------------
      // Create Current User
      // ---------------------------------------------------------

      final user = CurrentUser(
        // -------------------------------------------------------
        // Common
        // -------------------------------------------------------

        userId: company['id'].toString(),

        loginName:
        company['username']?.toString() ?? username,

        fullName:
        company['username']?.toString() ?? username,

        email:
        company['email']?.toString() ?? '',

        userType: UserType.company,

        role: UserRole.companyOwner,

        // -------------------------------------------------------
        // Employee
        // -------------------------------------------------------

        employeeId: '',
        employeeCode: null,
        employeeName: null,

        // -------------------------------------------------------
        // Company
        // -------------------------------------------------------

        companyId: companyId,
        companyName: companyName,

        // -------------------------------------------------------
        // Department
        // -------------------------------------------------------

        departmentId: null,
        departmentName: null,

        // -------------------------------------------------------
        // Designation
        // -------------------------------------------------------

        designationId: null,
        designationName: null,
      );

      await _saveSession(user);

      return user;
    }

    // ===========================================================
    // 3. EMPLOYEE LOGIN
    // ===========================================================

    final employee = await _client
        .from('employee_accounts')
        .select()
        .eq('username', username)
        .eq('password_hash', passwordHash)
        .eq('is_active', true)
        .maybeSingle();

    print('Employee Account => $employee');

    if (employee != null) {
      // =========================================================
      // Employee Information
      // =========================================================

      final employeeId =
          employee['employee_id']?.toString() ?? '';

      final employeeCode =
      employee['employee_code']?.toString();

      final employeeName =
      employee['full_name']?.toString();

      // =========================================================
      // Company Information
      // =========================================================

      final companyId =
          employee['company_id']?.toString() ?? '';

      String? companyName;

      if (companyId.isNotEmpty) {
        final companyData = await _client
            .from('companies')
            .select('id, name')
            .eq('id', companyId)
            .maybeSingle();

        companyName =
            companyData?['name']?.toString();
      }

      // =========================================================
      // Department Information
      // =========================================================

      final departmentId =
      employee['department_id']?.toString();

      String? departmentName;

      if (departmentId != null &&
          departmentId.isNotEmpty) {
        final departmentData = await _client
            .from('departments')
            .select('id, name')
            .eq('id', departmentId)
            .maybeSingle();

        departmentName =
            departmentData?['name']?.toString();
      }

      // =========================================================
      // Designation Information
      // =========================================================

      final designationId =
      employee['designation_id']?.toString();

      String? designationName;

      if (designationId != null &&
          designationId.isNotEmpty) {
        final designationData = await _client
            .from('designations')
            .select('id, name')
            .eq('id', designationId)
            .maybeSingle();

        designationName =
            designationData?['name']?.toString();
      }

      // =========================================================
      // SUPERVISOR CHECK
      // =========================================================
      //
      // IMPORTANT:
      //
      // Employee login first হবে।
      //
      // তারপর check:
      //
      // supervisors
      //      ↓
      // active?
      //      ↓
      // supervisor_departments
      //      ↓
      // department assigned?
      //
      // দুই condition true হলে supervisor।
      //
      // না হলে normal employee।
      //
      // =========================================================

      final isSupervisor =
      await _isActiveSupervisorWithDepartment(
        employeeId: employeeId,
      );

      print(
        'FINAL SUPERVISOR STATUS => $isSupervisor',
      );

      // =========================================================
      // Determine User Type & Role
      // =========================================================

      final UserType userType = isSupervisor
          ? UserType.supervisor
          : UserType.employee;

      final UserRole role = isSupervisor
          ? UserRole.supervisor
          : UserRole.employee;

      // =========================================================
      // CREATE CURRENT USER
      // =========================================================

      final user = CurrentUser(
        // -------------------------------------------------------
        // Common
        // -------------------------------------------------------

        userId: employee['id'].toString(),

        loginName:
        employee['username']?.toString() ?? username,

        fullName:
        employeeName ??
            employee['username']?.toString() ??
            username,

        email:
        employee['email']?.toString() ?? '',

        userType: userType,

        role: role,

        // -------------------------------------------------------
        // Employee
        // -------------------------------------------------------

        employeeId: employeeId,

        employeeCode: employeeCode,

        employeeName: employeeName,

        // -------------------------------------------------------
        // Company
        // -------------------------------------------------------

        companyId: companyId,

        companyName: companyName,

        // -------------------------------------------------------
        // Department
        // -------------------------------------------------------

        departmentId: departmentId,

        departmentName: departmentName,

        // -------------------------------------------------------
        // Designation
        // -------------------------------------------------------

        designationId: designationId,

        designationName: designationName,
      );

      // =========================================================
      // LOGIN DEBUG
      // =========================================================

      print(
        '================ LOGIN SESSION ================',
      );

      print(
        'Login Name => ${user.loginName}',
      );

      print(
        'User Type => ${user.userType.name}',
      );

      print(
        'Role => ${user.role.value}',
      );

      print(
        'Employee ID => ${user.employeeId}',
      );

      print(
        'Employee Code => ${user.employeeCode}',
      );

      print(
        'Employee Name => ${user.employeeName}',
      );

      print(
        'Company ID => ${user.companyId}',
      );

      print(
        'Company Name => ${user.companyName}',
      );

      print(
        'Department ID => ${user.departmentId}',
      );

      print(
        'Department Name => ${user.departmentName}',
      );

      print(
        'Designation ID => ${user.designationId}',
      );

      print(
        'Designation Name => ${user.designationName}',
      );

      print(
        'Is Supervisor => $isSupervisor',
      );

      // =========================================================
      // SAVE SESSION
      // =========================================================

      await _saveSession(user);

      return user;
    }

    // ===========================================================
    // INVALID LOGIN
    // ===========================================================

    throw Exception(
      'Invalid username or password.',
    );
  }

  // =============================================================
  // LOGOUT
  // =============================================================

  Future<void> logout() async {
    await _clearSession();
  }

  // =============================================================
  // CURRENT USER
  // =============================================================

  Future<CurrentUser?> currentUser() async {
    final prefs =
    await SharedPreferences.getInstance();

    final json =
    prefs.getString(_sessionKey);

    if (json == null ||
        json.trim().isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> data =
      jsonDecode(json);

      // ---------------------------------------------------------
      // User Type
      // ---------------------------------------------------------

      final userType =
      UserType.values.firstWhere(
            (e) => e.name == data['userType'],
        orElse: () => UserType.employee,
      );

      // ---------------------------------------------------------
      // Current User
      // ---------------------------------------------------------

      return CurrentUser(
        // -------------------------------------------------------
        // Common
        // -------------------------------------------------------

        userId:
        data['userId']?.toString() ?? '',

        loginName:
        data['loginName']?.toString() ?? '',

        fullName:
        data['fullName']?.toString() ?? '',

        email:
        data['email']?.toString() ?? '',

        userType: userType,

        role:
        UserRoleExtension.fromString(
          data['role']?.toString(),
        ),

        // -------------------------------------------------------
        // Employee
        // -------------------------------------------------------

        employeeId:
        data['employeeId']?.toString() ?? '',

        employeeCode:
        data['employeeCode']?.toString(),

        employeeName:
        data['employeeName']?.toString(),

        // -------------------------------------------------------
        // Company
        // -------------------------------------------------------

        companyId:
        data['companyId']?.toString() ?? '',

        companyName:
        data['companyName']?.toString(),

        // -------------------------------------------------------
        // Department
        // -------------------------------------------------------

        departmentId:
        data['departmentId']?.toString(),

        departmentName:
        data['departmentName']?.toString(),

        // -------------------------------------------------------
        // Designation
        // -------------------------------------------------------

        designationId:
        data['designationId']?.toString(),

        designationName:
        data['designationName']?.toString(),
      );
    } catch (e) {
      await _clearSession();

      return null;
    }
  }

  // =============================================================
  // CHANGE EMPLOYEE PASSWORD
  // =============================================================

  Future<void> changeEmployeePassword({
    required String employeeId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await _client
        .from('employee_accounts')
        .update({
      'password_hash': newPassword,
      'password_changed_at':
      DateTime.now().toIso8601String(),
      'force_change_password': false,
      'password_reset_token': null,
      'password_reset_expire_at': null,
      'updated_at':
      DateTime.now().toIso8601String(),
    })
        .eq('employee_id', employeeId)
        .eq('password_hash', currentPassword)
        .eq('is_active', true)
        .select('id')
        .maybeSingle();

    if (result == null) {
      throw Exception(
        'Current password is incorrect.',
      );
    }
  }
}