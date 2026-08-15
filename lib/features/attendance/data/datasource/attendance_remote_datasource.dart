import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/helpers/database_error_helper.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/attendance_model.dart';

/// ===============================================================
/// Flutter HRMS Pro
/// Attendance Remote DataSource
///
/// Responsibilities:
/// - Attendance CRUD
/// - Attendance search
/// - Employee attendance
/// - Date/date-range attendance
/// - Company attendance
/// - Department attendance
/// - Today attendance
/// - Check-in
/// - Check-out
/// - Supervisor attendance
/// - Supervisor employee report
///
/// IMPORTANT:
/// - Existing working attendance logic is preserved.
/// - Supervisor queries use company_id + department_id.
/// - No unnecessary employee/departments relation dependency.
/// - Database errors are converted through DatabaseErrorHelper.
/// ===============================================================

class AttendanceRemoteDataSource {
final SupabaseClient _client = SupabaseService.client;

// ==============================================================
// GET ALL
// ==============================================================

Future<List<AttendanceModel>> getAll() async {
try {
final response = await _client
    .from('attendance')
    .select()
    .order(
'attendance_date',
ascending: false,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// GET BY ID
// ==============================================================

Future<AttendanceModel?> getById(
String id,
) async {
try {
final attendanceId = id.trim();

if (attendanceId.isEmpty) {
throw Exception(
'Attendance ID is required.',
);
}

final response = await _client
    .from('attendance')
    .select()
    .eq(
'id',
attendanceId,
)
    .maybeSingle();

if (response == null) {
return null;
}

return AttendanceModel.fromMap(response);
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// INSERT
//
// Database generates ID automatically.
// ==============================================================

Future<void> insert(
AttendanceModel attendance,
) async {
try {
await _client
    .from('attendance')
    .insert(
attendance.toInsertMap(),
);
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// UPDATE
// ==============================================================

Future<void> update(
AttendanceModel attendance,
) async {
try {
if (attendance.id == null ||
attendance.id!.isEmpty) {
throw Exception(
'Attendance ID is required for update.',
);
}

await _client
    .from('attendance')
    .update(
attendance.toUpdateMap(),
)
    .eq(
'id',
attendance.id!,
);
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// DELETE
// ==============================================================

Future<void> delete(
String id,
) async {
try {
final attendanceId = id.trim();

if (attendanceId.isEmpty) {
throw Exception(
'Attendance ID is required.',
);
}

await _client
    .from('attendance')
    .delete()
    .eq(
'id',
attendanceId,
);
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// SEARCH
// ==============================================================

Future<List<AttendanceModel>> search(
String keyword,
) async {
try {
final value = keyword.trim();

if (value.isEmpty) {
return getAll();
}

final response = await _client
    .from('attendance')
    .select()
    .or(
'attendance_no.ilike.%$value%,'
'remarks.ilike.%$value%',
)
    .order(
'attendance_date',
ascending: false,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// BY EMPLOYEE
// ==============================================================

Future<List<AttendanceModel>> byEmployee(
String employeeId,
) async {
try {
final employee = employeeId.trim();

if (employee.isEmpty) {
throw Exception(
'Employee ID is required.',
);
}

final response = await _client
    .from('attendance')
    .select()
    .eq(
'employee_id',
employee,
)
    .order(
'attendance_date',
ascending: false,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// GET TODAY ATTENDANCE
// ==============================================================

Future<AttendanceModel?> getTodayAttendance(
String employeeId,
) async {
try {
final employee = employeeId.trim();

if (employee.isEmpty) {
throw Exception(
'Employee ID is required.',
);
}

final today = _formatDate(
DateTime.now(),
);

final response = await _client
    .from('attendance')
    .select()
    .eq(
'employee_id',
employee,
)
    .eq(
'attendance_date',
today,
)
    .maybeSingle();

if (response == null) {
return null;
}

return AttendanceModel.fromMap(response);
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// BY EMPLOYEE + DATE RANGE
//
// Supervisor Selected Employee Report
// ==============================================================

Future<List<AttendanceModel>> byEmployeeDateRange({
required String employeeId,
required DateTime from,
required DateTime to,
}) async {
try {
final employee = employeeId.trim();

if (employee.isEmpty) {
throw Exception(
'Employee ID is required.',
);
}

final fromDate = _formatDate(from);
final toDate = _formatDate(to);

final response = await _client
    .from('attendance')
    .select()
    .eq(
'employee_id',
employee,
)
    .gte(
'attendance_date',
fromDate,
)
    .lte(
'attendance_date',
toDate,
)
    .order(
'attendance_date',
ascending: true,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// BY STATUS
// ==============================================================

Future<List<AttendanceModel>> byStatus(
String status,
) async {
try {
final value = status.trim();

if (value.isEmpty) {
throw Exception(
'Attendance status is required.',
);
}

final response = await _client
    .from('attendance')
    .select()
    .eq(
'attendance_status',
value,
)
    .order(
'attendance_date',
ascending: false,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// BY DATE
// ==============================================================

Future<List<AttendanceModel>> byDate(
DateTime date,
) async {
try {
final selectedDate = _formatDate(date);

final response = await _client
    .from('attendance')
    .select()
    .eq(
'attendance_date',
selectedDate,
)
    .order(
'check_in_time',
ascending: true,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// BY DATE RANGE
// ==============================================================

Future<List<AttendanceModel>> byDateRange({
required DateTime from,
required DateTime to,
}) async {
try {
final fromDate = _formatDate(from);
final toDate = _formatDate(to);

final response = await _client
    .from('attendance')
    .select()
    .gte(
'attendance_date',
fromDate,
)
    .lte(
'attendance_date',
toDate,
)
    .order(
'attendance_date',
ascending: false,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// BY COMPANY
// ==============================================================

Future<List<AttendanceModel>> byCompany(
String companyId,
) async {
try {
final company = companyId.trim();

if (company.isEmpty) {
throw Exception(
'Company ID is required.',
);
}

final response = await _client
    .from('attendance')
    .select()
    .eq(
'company_id',
company,
)
    .order(
'attendance_date',
ascending: false,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// BY DEPARTMENT
// ==============================================================

Future<List<AttendanceModel>> byDepartment(
String departmentId,
) async {
try {
final department = departmentId.trim();

if (department.isEmpty) {
throw Exception(
'Department ID is required.',
);
}

final response = await _client
    .from('attendance')
    .select()
    .eq(
'department_id',
department,
)
    .order(
'attendance_date',
ascending: false,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// CHECK-IN
// ==============================================================

Future<void> checkIn({
required String attendanceId,
required DateTime checkInTime,
double? latitude,
double? longitude,
String? deviceName,
String? deviceId,
}) async {
try {
final id = attendanceId.trim();

if (id.isEmpty) {
throw Exception(
'Attendance ID is required.',
);
}

await _client
    .from('attendance')
    .update({
'check_in_time':
checkInTime.toIso8601String(),
'check_in_latitude':
latitude,
'check_in_longitude':
longitude,
'device_name':
deviceName,
'device_id':
deviceId,
})
    .eq(
'id',
id,
);
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// CHECK-OUT
// ==============================================================

Future<void> checkOut({
required String attendanceId,
required DateTime checkOutTime,
double? latitude,
double? longitude,
}) async {
try {
final id = attendanceId.trim();

if (id.isEmpty) {
throw Exception(
'Attendance ID is required.',
);
}

await _client
    .from('attendance')
    .update({
'check_out_time':
checkOutTime.toIso8601String(),
'check_out_latitude':
latitude,
'check_out_longitude':
longitude,
})
    .eq(
'id',
id,
);
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// ALREADY CHECKED IN
// ==============================================================

Future<bool> alreadyCheckedIn(
String employeeId,
) async {
final attendance =
await getTodayAttendance(employeeId);

return attendance != null;
}

// ==============================================================
// ALREADY CHECKED OUT
// ==============================================================

Future<bool> alreadyCheckedOut(
String employeeId,
) async {
final attendance =
await getTodayAttendance(employeeId);

if (attendance == null) {
return false;
}

return attendance.checkOutTime != null;
}

// ==============================================================
// SUPERVISOR - TODAY ATTENDANCE
//
// Company + Department + Today
//
// IMPORTANT:
// Employee relation এখানে ব্যবহার করা হচ্ছে না।
// তাই relation-name dependency নেই।
// ==============================================================

Future<List<AttendanceModel>>
supervisorTodayAttendance({
required String companyId,
required String departmentId,
}) async {
try {
final company = companyId.trim();
final department = departmentId.trim();

if (company.isEmpty) {
throw Exception(
'Company ID is required.',
);
}

if (department.isEmpty) {
throw Exception(
'Department ID is required.',
);
}

final today = _formatDate(
DateTime.now(),
);

final response = await _client
    .from('attendance')
    .select()
    .eq(
'company_id',
company,
)
    .eq(
'department_id',
department,
)
    .eq(
'attendance_date',
today,
)
    .eq(
'is_active',
true,
)
    .order(
'check_in_time',
ascending: true,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// SUPERVISOR - EMPLOYEE TODAY ATTENDANCE
// ==============================================================

Future<AttendanceModel?> supervisorEmployeeTodayAttendance({
required String companyId,
required String departmentId,
required String employeeId,
}) async {
try {
final company = companyId.trim();
final department = departmentId.trim();
final employee = employeeId.trim();

if (company.isEmpty) {
throw Exception(
'Company ID is required.',
);
}

if (department.isEmpty) {
throw Exception(
'Department ID is required.',
);
}

if (employee.isEmpty) {
throw Exception(
'Employee ID is required.',
);
}

final today = _formatDate(
DateTime.now(),
);

final response = await _client
    .from('attendance')
    .select()
    .eq(
'company_id',
company,
)
    .eq(
'department_id',
department,
)
    .eq(
'employee_id',
employee,
)
    .eq(
'attendance_date',
today,
)
    .maybeSingle();

if (response == null) {
return null;
}

return AttendanceModel.fromMap(
response,
);
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// SUPERVISOR - DEPARTMENT DATE RANGE
//
// Company + Department + Date Range
// ==============================================================

Future<List<AttendanceModel>>
supervisorDepartmentDateRange({
required String companyId,
required String departmentId,
required DateTime from,
required DateTime to,
}) async {
try {
final company = companyId.trim();
final department = departmentId.trim();

if (company.isEmpty) {
throw Exception(
'Company ID is required.',
);
}

if (department.isEmpty) {
throw Exception(
'Department ID is required.',
);
}

final fromDate = _formatDate(from);
final toDate = _formatDate(to);

final response = await _client
    .from('attendance')
    .select()
    .eq(
'company_id',
company,
)
    .eq(
'department_id',
department,
)
    .gte(
'attendance_date',
fromDate,
)
    .lte(
'attendance_date',
toDate,
)
    .order(
'attendance_date',
ascending: true,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// SUPERVISOR - EMPLOYEE DATE RANGE
//
// Selected Employee Report
//
// Company + Department + Employee + Date Range
// ==============================================================

Future<List<AttendanceModel>>
supervisorEmployeeDateRange({
required String companyId,
required String departmentId,
required String employeeId,
required DateTime from,
required DateTime to,
}) async {
try {
final company = companyId.trim();
final department = departmentId.trim();
final employee = employeeId.trim();

if (company.isEmpty) {
throw Exception(
'Company ID is required.',
);
}

if (department.isEmpty) {
throw Exception(
'Department ID is required.',
);
}

if (employee.isEmpty) {
throw Exception(
'Employee ID is required.',
);
}

final fromDate = _formatDate(from);
final toDate = _formatDate(to);

final response = await _client
    .from('attendance')
    .select()
    .eq(
'company_id',
company,
)
    .eq(
'department_id',
department,
)
    .eq(
'employee_id',
employee,
)
    .gte(
'attendance_date',
fromDate,
)
    .lte(
'attendance_date',
toDate,
)
    .order(
'attendance_date',
ascending: true,
);

return response
    .map<AttendanceModel>(
(e) => AttendanceModel.fromMap(e),
)
    .toList();
} on PostgrestException catch (e) {
throw Exception(
DatabaseErrorHelper.getMessage(e),
);
} catch (e) {
rethrow;
}
}

// ==============================================================
// REFRESH TODAY ATTENDANCE
// ==============================================================

Future<AttendanceModel?> refreshTodayAttendance(
String employeeId,
) async {
return getTodayAttendance(
employeeId,
);
}

// ==============================================================
// DATE FORMAT
// ==============================================================

String _formatDate(
DateTime date,
) {
return '${date.year.toString().padLeft(4, '0')}-'
'${date.month.toString().padLeft(2, '0')}-'
'${date.day.toString().padLeft(2, '0')}';
}
}
