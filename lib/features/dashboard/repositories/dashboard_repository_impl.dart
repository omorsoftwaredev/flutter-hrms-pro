/// ===============================================================
/// Flutter HRMS Pro
/// Dashboard Repository Implementation
///
/// Version : 0.7.0
/// ===============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/supabase_service.dart';
import '../models/dashboard_model.dart';
import 'dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl();

  final SupabaseClient _client = SupabaseService.client;

  @override
  Future<DashboardModel> loadDashboard() async {
    try {
      // ===========================================================
      // Company Count
      // ===========================================================

      final companies =
      await _client.from('companies').select();

      // ===========================================================
      // Department Count
      // ===========================================================

      final departments =
      await _client.from('departments').select();

      // ===========================================================
      // Employee Count
      // ===========================================================

      final employees =
      await _client.from('employees').select();

      // ===========================================================
      // Today Attendance
      // ===========================================================

      final today =
          DateTime.now().toIso8601String().split('T').first;

      final attendance =
      await _client
          .from('attendance')
          .select()
          .eq('attendance_date', today);

      // ===========================================================
      // Statistics
      // ===========================================================

      int present = 0;
      int absent = 0;
      int late = 0;

      for (final item in attendance) {
        final status =
            item['attendance_status']?.toString() ?? '';

        switch (status.toLowerCase()) {
          case 'present':
            present++;
            break;

          case 'absent':
            absent++;
            break;

          case 'late':
            late++;
            break;
        }
      }

      return DashboardModel(
        companies: companies.length,
        departments: departments.length,
        employees: employees.length,
        present: present,
        absent: absent,
        late: late,
      );
    } catch (e) {
      throw Exception(
        'Failed to load dashboard.\n$e',
      );
    }
  }
}