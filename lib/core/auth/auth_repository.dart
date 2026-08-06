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

  //==============================================================
  // Session Key
  //==============================================================

  static const String _sessionKey = 'current_user';

  //==============================================================
  // Save Session
  //==============================================================

  Future<void> _saveSession(CurrentUser user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _sessionKey,
      jsonEncode({
        'userId': user.userId,
        'employeeId': user.employeeId,
        'companyId': user.companyId,
        'fullName': user.fullName,
        'email': user.email,
        'role': user.role.value,
        'userType': user.userType.name,
      }),
    );
  }

  //==============================================================
  // Clear Session
  //==============================================================

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  //==============================================================
  // Login
  //==============================================================

  Future<CurrentUser> login({
    required String username,
    required String passwordHash,
  }) async {

    print('================ LOGIN ================');
    print('Username: $username');
    print('passwordHash: $passwordHash');
    //----------------------------------------------------------
    // Developer Login
    //----------------------------------------------------------

    // final developer = await _client
    //     .from('developers')
    //     .select()
    //     .eq('username', username)
    //     .eq('password_hash', passwordHash)
    //     .maybeSingle();

    // final developer = await _client
    //     .from('developers')
    //     .select('*')
    //     .eq('username', username)
    //     .maybeSingle();
    //
    // print('Developer => $developer');

    final developer = await _client
        .from('developers')
        .select()
        .eq('username', username)
        .eq('password_hash', passwordHash)
        .maybeSingle();

    print('Developer => $developer');

    if (developer != null) {
      final user = CurrentUser(
        userId: developer['id'].toString(),
        employeeId: '',
        companyId: '',
        fullName: developer['full_name'] ?? '',
        email: developer['email'] ?? '',
        userType: UserType.developer,
        role: UserRole.developer,
      );
      print('developer Result: $developer');
      await _saveSession(user);

      return user;
    }
    else
      {
        print('developer Result: null null 123456');
      }

    //----------------------------------------------------------
    // Company Login
    //----------------------------------------------------------

    final company = await _client
        .from('company_accounts')
        .select()
        .eq('username', username)
        .eq('password_hash', passwordHash)
        .eq('is_active', true)
        .maybeSingle();

    if (company != null) {
      final user = CurrentUser(
        userId: company['id'].toString(),
        employeeId: '',
        companyId: company['company_id'].toString(),
        fullName: company['username'] ?? '',
        email: '',
        userType: UserType.company,
        role: UserRole.companyOwner,
      );
      print('Company Result: $company');
      await _saveSession(user);

      return user;
    }
    else
    {
      print('Company Result: null null 123456');
    }

    //----------------------------------------------------------
    // Employee Login
    //----------------------------------------------------------
    //
    // final employee = await _client
    //     .from('employees')
    //     .select()
    //     .eq('employee_code', username)
    //     .eq('password_hash', passwordHash)
    //     .eq('is_active', true)
    //     .maybeSingle();
    //
    // if (employee != null) {
    //   final role = UserRoleExtension.fromString(
    //     employee['role'],
    //   );
    //
    //   UserType type = UserType.employee;
    //
    //   switch (role) {
    //     case UserRole.hr:
    //       type = UserType.hr;
    //       break;
    //
    //     case UserRole.supervisor:
    //       type = UserType.supervisor;
    //       break;
    //
    //     default:
    //       type = UserType.employee;
    //   }
    //
    //   final user = CurrentUser(
    //     userId: employee['id'].toString(),
    //     employeeId: employee['id'].toString(),
    //     companyId: employee['company_id'].toString(),
    //     fullName: employee['full_name'] ?? '',
    //     email: employee['email'] ?? '',
    //     userType: type,
    //     role: role,
    //   );
    //
    //   await _saveSession(user);
    //
    //   return user;
    // }

    throw Exception(
      'Invalid username or password.',
    );
  }

  //==============================================================
  // Logout
  //==============================================================

  Future<void> logout() async {
    await _clearSession();
  }

  //==============================================================
  // Current User
  //==============================================================

  Future<CurrentUser?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString(_sessionKey);

    if (json == null) {
      return null;
    }

    final data = jsonDecode(json);

    return CurrentUser(
      userId: data['userId'],
      employeeId: data['employeeId'],
      companyId: data['companyId'],
      fullName: data['fullName'],
      email: data['email'],
      role: UserRoleExtension.fromString(
        data['role'],
      ),
      userType: UserType.values.firstWhere(
            (e) => e.name == data['userType'],
      ),
    );
  }
}