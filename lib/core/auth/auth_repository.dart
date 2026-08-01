/// ===============================================================
/// Flutter HRMS Pro
/// Authentication Repository
///
/// Version : 0.8.0
/// ===============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';
import 'current_user.dart';
import 'roles.dart';

class AuthRepository {
  AuthRepository();

  final SupabaseClient _client = SupabaseService.client;

  // =============================================================
  // Root Developer Email
  // =============================================================

  static const String rootDeveloperEmail =
      'omor.software.dev@gmail.com';

  // =============================================================
  // Current User
  // =============================================================

  Future<CurrentUser?> currentUser() async {
    final authUser = _client.auth.currentUser;

    if (authUser == null) {
      return null;
    }

    // ===========================================================
    // Root Developer
    // ===========================================================

    if ((authUser.email ?? '').toLowerCase() ==
        rootDeveloperEmail.toLowerCase()) {
      return CurrentUser(
        userId: authUser.id,
        employeeId: '',
        companyId: '',
        fullName: 'Root Developer',
        email: authUser.email ?? '',
        role: UserRole.developer,
      );
    }

    // ===========================================================
    // Employee Login
    // ===========================================================

    final response = await _client
        .from('employees')
        .select()
        .eq('user_id', authUser.id)
        .maybeSingle();

    if (response == null) {
      throw Exception(
        'Employee profile not found.',
      );
    }

    return CurrentUser(
      userId: authUser.id,
      employeeId: response['id']?.toString() ?? '',
      companyId: response['company_id']?.toString() ?? '',
      fullName: response['full_name'] ?? '',
      email: response['email'] ?? authUser.email ?? '',
      role: UserRoleExtension.fromString(
        response['role'],
      ),
    );
  }

  // =============================================================
  // Login
  // =============================================================

  Future<CurrentUser?> login({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return currentUser();
  }

  // =============================================================
  // Logout
  // =============================================================

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // =============================================================
  // Is Logged In
  // =============================================================

  bool get isLoggedIn =>
      _client.auth.currentUser != null;
}