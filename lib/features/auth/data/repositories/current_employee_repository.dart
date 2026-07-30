import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../employee/data/models/employee_model.dart';

class CurrentEmployeeRepository {
  CurrentEmployeeRepository();

  final _client = Supabase.instance.client;

  Future<EmployeeModel?> currentEmployee() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final json = await _client
        .from('employees')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (json == null) {
      return null;
    }

    return EmployeeModel.fromJson(json);
  }
}