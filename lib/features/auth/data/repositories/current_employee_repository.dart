import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../employee/data/models/employee_model.dart';
import '../../../../core/auth/auth_repository.dart';

class CurrentEmployeeRepository {
  CurrentEmployeeRepository();

  final SupabaseClient _client = Supabase.instance.client;

  // ============================================================
  // Current Employee
  //
  // Employee Login Flow:
  //
  // employee_accounts
  //        ↓
  // employee_id
  //        ↓
  // employees.id
  //
  // ============================================================

  Future<EmployeeModel?> currentEmployee() async {
    try {
      // ----------------------------------------------------------
      // Get current logged-in application user
      // ----------------------------------------------------------

      final currentUser = await AuthRepository().currentUser();

      print('CURRENT USER => ${currentUser?.userId}');

      print('CURRENT EMPLOYEE ID => ${currentUser?.employeeId}');

      // ----------------------------------------------------------
      // No session
      // ----------------------------------------------------------

      if (currentUser == null) {
        print('CURRENT EMPLOYEE => No logged-in user');

        return null;
      }

      // ----------------------------------------------------------
      // Only Employee can use this repository
      // ----------------------------------------------------------

      if (currentUser.employeeId.isEmpty) {
        print('CURRENT EMPLOYEE => Employee ID is empty');

        return null;
      }

      // ----------------------------------------------------------
      // Find employee by employee_accounts.employee_id
      // ----------------------------------------------------------

      final json = await _client
          .from('employees')
          .select()
          .eq('id', currentUser.employeeId)
          .maybeSingle();

      // ----------------------------------------------------------
      // Employee not found
      // ----------------------------------------------------------

      if (json == null) {
        print('CURRENT EMPLOYEE => Employee not found');

        print(
          'SEARCHED EMPLOYEE ID => '
          '${currentUser.employeeId}',
        );

        return null;
      }

      // ----------------------------------------------------------
      // Employee found
      // ----------------------------------------------------------

      print('CURRENT EMPLOYEE => Employee found');

      print('EMPLOYEE ID => ${json['id']}');

      print('EMPLOYEE NAME => ${json['full_name']}');

      return EmployeeModel.fromJson(json);
    } catch (e) {
      print('CURRENT EMPLOYEE ERROR => $e');

      rethrow;
    }
  }
}
