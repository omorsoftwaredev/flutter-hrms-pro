// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Employee Attendance Report Page
//
// Purpose:
// - Load active supervisors for a company
// - Join supervisors.employee_id with employees.id
// - Read supervisor name from employees.full_name
// - Selecting supervisor loads assigned departments
// - Department assignment:
//       supervisors.id
//            ↓
//       supervisor_departments.supervisor_id
//            ↓
//       supervisor_departments.department_id
//            ↓
//       departments.id
// - Do NOT modify existing SupervisorModel / Supervisor Entity
// - Do NOT use company_employees
// - Do NOT use PostgREST .in_()
// - Use explicit Supabase relationship for employees
// - Keep supervisor data isolated inside this report page
//
// Version : 3.0.0
// ============================================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ============================================================================
// PAGE
// ============================================================================

class CompanySupervisorMobileAttendanceReportPage
    extends StatefulWidget {
  const CompanySupervisorMobileAttendanceReportPage({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  State<CompanySupervisorMobileAttendanceReportPage> createState() =>
      _CompanySupervisorEmployeeAttendanceReportPageState();
}

// ============================================================================
// STATE
// ============================================================================

class _CompanySupervisorEmployeeAttendanceReportPageState
    extends State<CompanySupervisorMobileAttendanceReportPage> {
  // ==========================================================================
  // SUPABASE
  // ==========================================================================

  final SupabaseClient _supabase =
      Supabase.instance.client;

  // ==========================================================================
  // SUPERVISOR STATE
  // ==========================================================================

  bool _isLoadingSupervisors = false;

  String? _supervisorError;

  List<Map<String, dynamic>> _supervisors = [];

  // ==========================================================================
  // SELECTED SUPERVISOR
  // ==========================================================================

  String? _selectedSupervisorId;

  String? _selectedSupervisorName;

  String? _selectedSupervisorEmployeeId;

  // ==========================================================================
  // DEPARTMENT STATE
  // ==========================================================================

  bool _isLoadingDepartments = false;

  String? _departmentError;

  List<Map<String, dynamic>> _departments = [];

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSupervisors();
    });
  }

  // ==========================================================================
  // COMPANY ID
  // ==========================================================================

  String get companyId {
    return widget.companyId.trim();
  }

  // ==========================================================================
  // LOAD SUPERVISORS
  // ==========================================================================

  Future<void> _loadSupervisors() async {
    debugPrint('');

    debugPrint(
      '============================================================',
    );

    debugPrint(
      'PAGE — LOAD SUPERVISORS',
    );

    debugPrint(
      '============================================================',
    );

    debugPrint(
      '[SupervisorPage] Company ID: "$companyId"',
    );

    // =========================================================================
    // VALIDATE COMPANY ID
    // =========================================================================

    if (companyId.isEmpty) {
      debugPrint(
        '[SupervisorPage] ERROR: Company ID is empty.',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingSupervisors = false;
        _supervisorError = 'Company ID is required.';
        _supervisors = [];
        _selectedSupervisorId = null;
        _selectedSupervisorName = null;
        _selectedSupervisorEmployeeId = null;
        _departments = [];
      });

      return;
    }

    // =========================================================================
    // START LOADING
    // =========================================================================

    if (mounted) {
      setState(() {
        _isLoadingSupervisors = true;
        _supervisorError = null;
        _supervisors = [];

        _selectedSupervisorId = null;
        _selectedSupervisorName = null;
        _selectedSupervisorEmployeeId = null;

        _departments = [];
        _departmentError = null;
      });
    }

    try {
      // =======================================================================
      // STEP 1
      // GET ACTIVE SUPERVISORS
      //
      // supervisors.employee_id
      //          ↓
      // employees.id
      //
      // Explicit relationship:
      // employees!fk_supervisors_employee
      // =======================================================================

      debugPrint('');

      debugPrint(
        '------------------------------------------------------------',
      );

      debugPrint(
        '[SupervisorPage] STEP 1 — SUPERVISOR QUERY',
      );

      debugPrint(
        '------------------------------------------------------------',
      );

      debugPrint(
        '[SupervisorPage] Table: supervisors',
      );

      debugPrint(
        '[SupervisorPage] company_id = "$companyId"',
      );

      debugPrint(
        '[SupervisorPage] is_active = true',
      );

      debugPrint(
        '[SupervisorPage] JOIN = employees!fk_supervisors_employee',
      );

      final List<dynamic> supervisorResponse =
      await _supabase
          .from('supervisors')
          .select('''
                id,
                employee_id,
                company_id,
                department_id,
                supervisors_code,
                is_active,
                created_at,
                updated_at,
                created_by,
                updated_by,
                employees!fk_supervisors_employee (
                  id,
                  full_name
                )
              ''')
          .eq(
        'company_id',
        companyId,
      )
          .eq(
        'is_active',
        true,
      )
          .order(
        'created_at',
        ascending: true,
      );

      // =========================================================================
      // RESPONSE DEBUG
      // =========================================================================

      debugPrint('');

      debugPrint(
        '[SupervisorPage] Supervisor response count: '
            '${supervisorResponse.length}',
      );

      debugPrint(
        '[SupervisorPage] Supervisor RAW RESPONSE:',
      );

      debugPrint(
        '$supervisorResponse',
      );

      // =========================================================================
      // NO SUPERVISOR
      // =========================================================================

      if (supervisorResponse.isEmpty) {
        debugPrint(
          '[SupervisorPage] No active supervisors found.',
        );

        if (!mounted) {
          return;
        }

        setState(() {
          _isLoadingSupervisors = false;
          _supervisorError = null;
          _supervisors = [];

          _selectedSupervisorId = null;
          _selectedSupervisorName = null;
          _selectedSupervisorEmployeeId = null;

          _departments = [];
          _departmentError = null;
        });

        return;
      }

      // =========================================================================
      // STEP 2
      // PREPARE SUPERVISOR DATA
      // =========================================================================

      final List<Map<String, dynamic>> supervisors = [];

      for (final dynamic item in supervisorResponse) {
        if (item is! Map) {
          debugPrint(
            '[SupervisorPage] WARNING: Invalid supervisor row: $item',
          );

          continue;
        }

        final Map<String, dynamic> supervisor =
        Map<String, dynamic>.from(item);

        // =======================================================================
        // SUPERVISOR ID
        // =======================================================================

        final String supervisorId =
            supervisor['id']
                ?.toString()
                .trim() ??
                '';

        // =======================================================================
        // EMPLOYEE ID
        // =======================================================================

        final String employeeId =
            supervisor['employee_id']
                ?.toString()
                .trim() ??
                '';

        // =======================================================================
        // SUPERVISOR CODE
        // =======================================================================

        final String supervisorCode =
            supervisor['supervisors_code']
                ?.toString()
                .trim() ??
                '';

        // =======================================================================
        // DEPARTMENT ID
        // =======================================================================

        final String departmentId =
            supervisor['department_id']
                ?.toString()
                .trim() ??
                '';

        // =======================================================================
        // EMPLOYEE JOIN
        // =======================================================================

        final dynamic employeeData =
        supervisor['employees'];

        String supervisorName =
            'Unknown Supervisor';

        if (employeeData is Map) {
          final String employeeName =
              employeeData['full_name']
                  ?.toString()
                  .trim() ??
                  '';

          if (employeeName.isNotEmpty) {
            supervisorName = employeeName;
          }
        }

        // =======================================================================
        // STORE NAME
        // =======================================================================

        supervisor['supervisor_name'] =
            supervisorName;

        supervisors.add(
          supervisor,
        );

        // =======================================================================
        // DEBUG
        // =======================================================================

        debugPrint('');

        debugPrint(
          '------------------------------------------------------------',
        );

        debugPrint(
          '[SupervisorPage] SUPERVISOR RECORD',
        );

        debugPrint(
          '[SupervisorPage] Supervisor ID: $supervisorId',
        );

        debugPrint(
          '[SupervisorPage] Employee ID: $employeeId',
        );

        debugPrint(
          '[SupervisorPage] Supervisor Name: $supervisorName',
        );

        debugPrint(
          '[SupervisorPage] Supervisor Code: $supervisorCode',
        );

        debugPrint(
          '[SupervisorPage] Company ID: '
              '${supervisor['company_id'] ?? ''}',
        );

        debugPrint(
          '[SupervisorPage] Department ID: $departmentId',
        );

        debugPrint(
          '[SupervisorPage] Is Active: '
              '${supervisor['is_active']}',
        );

        debugPrint(
          '------------------------------------------------------------',
        );
      }

      // =========================================================================
      // SAVE
      // =========================================================================

      if (!mounted) {
        return;
      }

      setState(() {
        _supervisors = supervisors;
        _isLoadingSupervisors = false;
        _supervisorError = null;
      });

      debugPrint('');

      debugPrint(
        '============================================================',
      );

      debugPrint(
        '[SupervisorPage] FINAL SUPERVISOR COUNT: '
            '${_supervisors.length}',
      );

      debugPrint(
        '[SupervisorPage] Supervisors loaded successfully.',
      );

      debugPrint(
        '============================================================',
      );
    } catch (e, stackTrace) {
      debugPrint('');

      debugPrint(
        '============================================================',
      );

      debugPrint(
        'SUPERVISOR QUERY POSTGRES ERROR',
      );

      debugPrint(
        '============================================================',
      );

      debugPrint(
        '[SupervisorPage] Error: $e',
      );

      debugPrint(
        '[SupervisorPage] Error type: ${e.runtimeType}',
      );

      debugPrint(
        '[SupervisorPage] StackTrace:',
      );

      debugPrint(
        '$stackTrace',
      );

      debugPrint(
        '============================================================',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingSupervisors = false;
        _supervisors = [];
        _supervisorError = e.toString();

        _selectedSupervisorId = null;
        _selectedSupervisorName = null;
        _selectedSupervisorEmployeeId = null;

        _departments = [];
        _departmentError = null;
      });
    }
  }

  // ==========================================================================
  // LOAD DEPARTMENTS FOR SELECTED SUPERVISOR
  //
  // IMPORTANT:
  //
  // Here supervisor ID MUST be:
  //
  // supervisors.id
  //
  // NOT:
  //
  // supervisors.employee_id
  //
  // Query:
  //
  // supervisor_departments.supervisor_id = supervisors.id
  //
  // Then:
  //
  // supervisor_departments.department_id
  //          ↓
  // departments.id
  // ==========================================================================
  Future<void> _loadDepartmentsForSupervisor(
      String supervisorId,
      ) async {
    final String normalizedSupervisorId = supervisorId.trim();

    debugPrint('');

    debugPrint(
      '============================================================',
    );

    debugPrint(
      'PAGE — LOAD SUPERVISOR DEPARTMENTS',
    );

    debugPrint(
      '============================================================',
    );

    debugPrint(
      '[DepartmentPage] Supervisor ID received: '
          '"$normalizedSupervisorId"',
    );

    debugPrint(
      '[DepartmentPage] IMPORTANT: This is supervisors.id',
    );

    if (normalizedSupervisorId.isEmpty) {
      debugPrint(
        '[DepartmentPage] ERROR: Supervisor ID is empty.',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingDepartments = false;
        _departmentError = 'Supervisor ID is required.';
        _departments = [];
      });

      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingDepartments = true;
        _departmentError = null;
        _departments = [];
      });
    }

    try {
      // =======================================================================
      // STEP 1
      // LOAD SUPERVISOR DEPARTMENT ASSIGNMENTS
      //
      // supervisor_departments.supervisor_id
      //              =
      // supervisors.id
      //
      // =======================================================================

      debugPrint('');

      debugPrint(
        '------------------------------------------------------------',
      );

      debugPrint(
        '[DepartmentPage] STEP 1 — SUPERVISOR DEPARTMENT QUERY',
      );

      debugPrint(
        '------------------------------------------------------------',
      );

      debugPrint(
        '[DepartmentPage] Table: supervisor_departments',
      );

      debugPrint(
        '[DepartmentPage] supervisor_id = '
            '"$normalizedSupervisorId"',
      );

      debugPrint(
        '[DepartmentPage] Query uses supervisors.id',
      );

      debugPrint(
        '[DepartmentPage] supervisor_departments columns:',
      );

      debugPrint(
        '[DepartmentPage] '
            'id, company_id, supervisor_id, department_id, '
            'created_at, created_by, updated_by',
      );

      final List<dynamic> assignmentResponse =
      await _supabase
          .from('supervisor_departments')
          .select('''
              id,
              company_id,
              supervisor_id,
              department_id,
              created_at,
              created_by,
              updated_by
            ''')
          .eq(
        'supervisor_id',
        normalizedSupervisorId,
      )
          .order(
        'created_at',
        ascending: true,
      );

      debugPrint('');

      debugPrint(
        '[DepartmentPage] Assignment count: '
            '${assignmentResponse.length}',
      );

      debugPrint(
        '[DepartmentPage] Assignment RAW RESPONSE:',
      );

      debugPrint(
        '$assignmentResponse',
      );

      // =======================================================================
      // NO ASSIGNED DEPARTMENT
      // =======================================================================

      if (assignmentResponse.isEmpty) {
        debugPrint(
          '[DepartmentPage] No departments assigned to this supervisor.',
        );

        if (!mounted) {
          return;
        }

        setState(() {
          _isLoadingDepartments = false;
          _departmentError = null;
          _departments = [];
        });

        debugPrint(
          '[DepartmentPage] Department list cleared.',
        );

        debugPrint(
          '============================================================',
        );

        return;
      }

      // =======================================================================
      // STEP 2
      // LOAD DEPARTMENT DETAILS
      //
      // Actual departments table schema:
      //
      // id
      // company_id
      // code
      // name
      // description
      // phone
      // email
      // location
      // is_active
      // created_at
      // updated_at
      // created_by
      // updated_by
      //
      // =======================================================================

      debugPrint('');

      debugPrint(
        '------------------------------------------------------------',
      );

      debugPrint(
        '[DepartmentPage] STEP 2 — DEPARTMENT DETAILS',
      );

      debugPrint(
        '------------------------------------------------------------',
      );

      debugPrint(
        '[DepartmentPage] Actual departments columns:',
      );

      debugPrint(
        '[DepartmentPage] '
            'id, company_id, code, name, description, '
            'phone, email, location, is_active, '
            'created_at, updated_at, created_by, updated_by',
      );

      final List<Map<String, dynamic>> departments = [];

      for (final dynamic item in assignmentResponse) {
        if (item is! Map) {
          debugPrint(
            '[DepartmentPage] WARNING: Invalid assignment item skipped.',
          );

          continue;
        }

        final Map<String, dynamic> assignment =
        Map<String, dynamic>.from(item);

        // =====================================================================
        // ASSIGNMENT DATA
        // =====================================================================

        final String assignmentId =
            assignment['id']
                ?.toString()
                .trim() ??
                '';

        final String assignmentCompanyId =
            assignment['company_id']
                ?.toString()
                .trim() ??
                '';

        final String assignmentSupervisorId =
            assignment['supervisor_id']
                ?.toString()
                .trim() ??
                '';

        final String departmentId =
            assignment['department_id']
                ?.toString()
                .trim() ??
                '';

        debugPrint('');

        debugPrint(
          '------------------------------------------------------------',
        );

        debugPrint(
          '[DepartmentPage] SUPERVISOR DEPARTMENT ASSIGNMENT',
        );

        debugPrint(
          '[DepartmentPage] Assignment ID: "$assignmentId"',
        );

        debugPrint(
          '[DepartmentPage] Assignment Company ID: '
              '"$assignmentCompanyId"',
        );

        debugPrint(
          '[DepartmentPage] Assignment Supervisor ID: '
              '"$assignmentSupervisorId"',
        );

        debugPrint(
          '[DepartmentPage] Selected Supervisor ID: '
              '"$normalizedSupervisorId"',
        );

        debugPrint(
          '[DepartmentPage] Department ID: "$departmentId"',
        );

        debugPrint(
          '------------------------------------------------------------',
        );

        // =====================================================================
        // VALIDATE DEPARTMENT ID
        // =====================================================================

        if (departmentId.isEmpty) {
          debugPrint(
            '[DepartmentPage] WARNING: Empty department_id.',
          );

          continue;
        }

        // =====================================================================
        // VALIDATE SUPERVISOR ID
        // =====================================================================

        if (assignmentSupervisorId.isNotEmpty &&
            assignmentSupervisorId != normalizedSupervisorId) {
          debugPrint(
            '[DepartmentPage] WARNING: Assignment supervisor mismatch.',
          );

          debugPrint(
            '[DepartmentPage] Expected: "$normalizedSupervisorId"',
          );

          debugPrint(
            '[DepartmentPage] Received: "$assignmentSupervisorId"',
          );

          continue;
        }

        try {
          debugPrint(
            '[DepartmentPage] Loading department...',
          );

          debugPrint(
            '[DepartmentPage] Department ID: "$departmentId"',
          );

          // ===================================================================
          // ACTUAL DEPARTMENT QUERY
          //
          // IMPORTANT:
          // name  = department name
          // code  = department code
          //
          // NOT:
          // department_name
          // department_code
          // ===================================================================

          final Map<String, dynamic>? departmentResponse =
          await _supabase
              .from('departments')
              .select('''
                  id,
                  company_id,
                  code,
                  name,
                  description,
                  phone,
                  email,
                  location,
                  is_active,
                  created_at,
                  updated_at,
                  created_by,
                  updated_by
                ''')
              .eq(
            'id',
            departmentId,
          )
              .maybeSingle();

          debugPrint(
            '[DepartmentPage] Department response:',
          );

          debugPrint(
            '$departmentResponse',
          );

          // ===================================================================
          // DEPARTMENT NOT FOUND
          // ===================================================================

          if (departmentResponse == null) {
            debugPrint(
              '[DepartmentPage] Department not found.',
            );

            debugPrint(
              '[DepartmentPage] Department ID: "$departmentId"',
            );

            continue;
          }

          final Map<String, dynamic> department =
          Map<String, dynamic>.from(
            departmentResponse,
          );

          // ===================================================================
          // ADD SUPERVISOR / ASSIGNMENT METADATA
          // ===================================================================

          department['supervisor_id'] =
              normalizedSupervisorId;

          department['assignment_id'] =
              assignmentId;

          department['assignment_company_id'] =
              assignmentCompanyId;

          // ===================================================================
          // VALIDATE COMPANY
          //
          // supervisor_departments.company_id
          // should match departments.company_id
          //
          // ===================================================================

          final String departmentCompanyId =
              department['company_id']
                  ?.toString()
                  .trim() ??
                  '';

          if (assignmentCompanyId.isNotEmpty &&
              departmentCompanyId.isNotEmpty &&
              assignmentCompanyId != departmentCompanyId) {
            debugPrint(
              '[DepartmentPage] WARNING: Company mismatch.',
            );

            debugPrint(
              '[DepartmentPage] Assignment company: '
                  '"$assignmentCompanyId"',
            );

            debugPrint(
              '[DepartmentPage] Department company: '
                  '"$departmentCompanyId"',
            );

            continue;
          }

          // ===================================================================
          // ADD DEPARTMENT
          // ===================================================================

          departments.add(
            department,
          );

          debugPrint(
            '[DepartmentPage] Department loaded successfully.',
          );

          debugPrint(
            '[DepartmentPage] Department ID: '
                '${department['id']}',
          );

          debugPrint(
            '[DepartmentPage] Department Name: '
                '${department['name']}',
          );

          debugPrint(
            '[DepartmentPage] Department Code: '
                '${department['code']}',
          );

          debugPrint(
            '[DepartmentPage] Is Active: '
                '${department['is_active']}',
          );
        } catch (e, stackTrace) {
          debugPrint('');

          debugPrint(
            '------------------------------------------------------------',
          );

          debugPrint(
            '[DepartmentPage] DEPARTMENT LOOKUP ERROR',
          );

          debugPrint(
            '------------------------------------------------------------',
          );

          debugPrint(
            '[DepartmentPage] Department ID: '
                '"$departmentId"',
          );

          debugPrint(
            '[DepartmentPage] Error: $e',
          );

          debugPrint(
            '[DepartmentPage] Error type: '
                '${e.runtimeType}',
          );

          debugPrint(
            '[DepartmentPage] StackTrace: $stackTrace',
          );

          debugPrint(
            '------------------------------------------------------------',
          );
        }
      }

      // =======================================================================
      // SAVE DEPARTMENTS
      // =======================================================================

      if (!mounted) {
        return;
      }

      setState(() {
        _departments = departments;
        _isLoadingDepartments = false;
        _departmentError = null;
      });

      // =======================================================================
      // FINAL LOG
      // =======================================================================

      debugPrint('');

      debugPrint(
        '============================================================',
      );

      debugPrint(
        '[DepartmentPage] FINAL DEPARTMENT COUNT: '
            '${_departments.length}',
      );

      if (_departments.isEmpty) {
        debugPrint(
          '[DepartmentPage] WARNING: '
              'Supervisor has no loadable departments.',
        );

        debugPrint(
          '[DepartmentPage] Supervisor ID checked: '
              '"$normalizedSupervisorId"',
        );
      }

      for (
      int index = 0;
      index < _departments.length;
      index++
      ) {
        final Map<String, dynamic> department =
        _departments[index];

        debugPrint(
          '[DepartmentPage][$index] '
              'id=${department['id']}, '
              'name=${department['name']}, '
              'code=${department['code']}, '
              'companyId=${department['company_id']}, '
              'supervisorId=${department['supervisor_id']}, '
              'assignmentId=${department['assignment_id']}, '
              'isActive=${department['is_active']}',
        );
      }

      debugPrint(
        '[DepartmentPage] Departments loaded successfully.',
      );

      debugPrint(
        '============================================================',
      );

      debugPrint(
        'PAGE — LOAD SUPERVISOR DEPARTMENTS END',
      );

      debugPrint(
        '============================================================',
      );
    } catch (e, stackTrace) {
      debugPrint('');

      debugPrint(
        '============================================================',
      );

      debugPrint(
        'SUPERVISOR DEPARTMENT QUERY ERROR',
      );

      debugPrint(
        '============================================================',
      );

      debugPrint(
        '[DepartmentPage] Error: $e',
      );

      debugPrint(
        '[DepartmentPage] Error type: ${e.runtimeType}',
      );

      debugPrint(
        '[DepartmentPage] StackTrace: $stackTrace',
      );

      debugPrint(
        '============================================================',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingDepartments = false;
        _departments = [];
        _departmentError = e.toString();
      });
    }
  }

  // ==========================================================================
  // GET SUPERVISOR NAME
  // ==========================================================================

  String _getSupervisorName(
      Map<String, dynamic> supervisor) {
    final String name =
        supervisor['supervisor_name']
            ?.toString()
            .trim() ??
            '';

    if (name.isNotEmpty) {
      return name;
    }

    return 'Supervisor';
  }

  // ==========================================================================
  // GET SUPERVISOR CODE
  // ==========================================================================

  String _getSupervisorCode(
      Map<String, dynamic> supervisor) {
    return supervisor['supervisors_code']
        ?.toString()
        .trim() ??
        '';
  }

  // ==========================================================================
  // GET DEPARTMENT ID
  // ==========================================================================

  String _getDepartmentId(
      Map<String, dynamic> supervisor) {
    return supervisor['department_id']
        ?.toString()
        .trim() ??
        '';
  }

  // ==========================================================================
  // GET EMPLOYEE ID
  // ==========================================================================

  String _getEmployeeId(
      Map<String, dynamic> supervisor) {
    return supervisor['employee_id']
        ?.toString()
        .trim() ??
        '';
  }

  // ==========================================================================
  // REFRESH
  // ==========================================================================

  Future<void> _refreshSupervisors() async {
    await _loadSupervisors();
  }

  // ==========================================================================
  // SELECT SUPERVISOR
  // ==========================================================================

  Future<void> _onSupervisorSelected(
      Map<String, dynamic> supervisor) async {
    final String supervisorId =
        supervisor['id']
            ?.toString()
            .trim() ??
            '';

    final String employeeId =
    _getEmployeeId(
      supervisor,
    );

    final String supervisorName =
    _getSupervisorName(
      supervisor,
    );

    // =========================================================================
    // VERY IMPORTANT
    //
    // supervisorId = supervisors.id
    //
    // employeeId = supervisors.employee_id
    //
    // Department query MUST use supervisorId.
    // =========================================================================

    debugPrint('');

    debugPrint(
      '============================================================',
    );

    debugPrint(
      'SUPERVISOR SELECTED',
    );

    debugPrint(
      '============================================================',
    );

    debugPrint(
      '[SupervisorPage] Name: "$supervisorName"',
    );

    debugPrint(
      '[SupervisorPage] Supervisor ID: "$supervisorId"',
    );

    debugPrint(
      '[SupervisorPage] Employee ID: "$employeeId"',
    );

    debugPrint(
      '[SupervisorPage] Department Loader Supervisor ID: '
          '"$supervisorId"',
    );

    debugPrint(
      '[SupervisorPage] Department query will use:',
    );

    debugPrint(
      'supervisor_departments.supervisor_id = '
          '$supervisorId',
    );

    debugPrint(
      '============================================================',
    );

    if (supervisorId.isEmpty) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Supervisor ID is missing.',
          ),
          behavior:
          SnackBarBehavior.floating,
        ),
      );

      return;
    }

    // =========================================================================
    // SAVE SELECTED SUPERVISOR
    // =========================================================================

    if (mounted) {
      setState(() {
        _selectedSupervisorId =
            supervisorId;

        _selectedSupervisorName =
            supervisorName;

        _selectedSupervisorEmployeeId =
            employeeId;
      });
    }

    // =========================================================================
    // LOAD ASSIGNED DEPARTMENTS
    // =========================================================================

    await _loadDepartmentsForSupervisor(
      supervisorId,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Supervisor Employee Attendance',
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
            _isLoadingSupervisors
                ? null
                : _refreshSupervisors,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh:
        _refreshSupervisors,
        child:
        _buildBody(theme),
      ),
    );
  }

  // ==========================================================================
  // BODY
  // ==========================================================================

  Widget _buildBody(
      ThemeData theme) {
    if (_isLoadingSupervisors) {
      return const Center(
        child:
        CircularProgressIndicator(),
      );
    }

    if (_supervisorError != null) {
      return _buildErrorState(
        theme,
      );
    }

    if (_supervisors.isEmpty) {
      return _buildEmptyState(
        theme,
      );
    }

    return _buildMainContent(
      theme,
    );
  }

  // ==========================================================================
  // MAIN CONTENT
  // ==========================================================================

  Widget _buildMainContent(
      ThemeData theme) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(16),
      children: [
        // =====================================================================
        // SUPERVISOR SECTION
        // =====================================================================

        Text(
          'Supervisors',
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w700,
          ),
        ),

        const SizedBox(
          height: 12,
        ),

        ..._supervisors.map(
              (supervisor) {
            final bool isSelected =
                _selectedSupervisorId ==
                    supervisor['id']
                        ?.toString();

            return Padding(
              padding:
              const EdgeInsets.only(
                bottom: 12,
              ),
              child:
              _buildSupervisorCard(
                theme:
                theme,
                supervisor:
                supervisor,
                supervisorName:
                _getSupervisorName(
                  supervisor,
                ),
                supervisorCode:
                _getSupervisorCode(
                  supervisor,
                ),
                departmentId:
                _getDepartmentId(
                  supervisor,
                ),
                isSelected:
                isSelected,
              ),
            );
          },
        ),

        // =====================================================================
        // DEPARTMENT SECTION
        // =====================================================================

        if (_selectedSupervisorId != null) ...[
          const SizedBox(
            height: 12,
          ),

          _buildSelectedSupervisorHeader(
            theme,
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            'Assigned Departments',
            style: theme
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          _buildDepartmentSection(
            theme,
          ),
        ],
      ],
    );
  }

  // ==========================================================================
  // SELECTED SUPERVISOR HEADER
  // ==========================================================================

  Widget _buildSelectedSupervisorHeader(
      ThemeData theme) {
    return Card(
      elevation: 0,
      color:
      theme.colorScheme.primaryContainer,
      child: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              child: Text(
                _getInitials(
                  _selectedSupervisorName ??
                      'Supervisor',
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Supervisor',
                    style: theme
                        .textTheme
                        .bodySmall,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    _selectedSupervisorName ??
                        'Supervisor',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: theme
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Supervisor ID: '
                        '${_selectedSupervisorId ?? ''}',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: theme
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // DEPARTMENT SECTION
  // ==========================================================================

  Widget _buildDepartmentSection(
      ThemeData theme) {
    if (_isLoadingDepartments) {
      return const Card(
        elevation: 0,
        child: Padding(
          padding:
          EdgeInsets.all(24),
          child: Center(
            child:
            CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_departmentError != null) {
      return Card(
        elevation: 0,
        child: Padding(
          padding:
          const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color:
                theme.colorScheme.error,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Unable to load departments',
                textAlign:
                TextAlign.center,
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                _departmentError!,
                textAlign:
                TextAlign.center,
                style: theme
                    .textTheme
                    .bodySmall,
              ),
              const SizedBox(
                height: 16,
              ),
              FilledButton.icon(
                onPressed:
                _selectedSupervisorId ==
                    null
                    ? null
                    : () {
                  _loadDepartmentsForSupervisor(
                    _selectedSupervisorId!,
                  );
                },
                icon:
                const Icon(
                  Icons.refresh,
                ),
                label:
                const Text(
                  'Try Again',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_departments.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding:
          const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons
                    .account_tree_outlined,
                size: 56,
                color:
                theme.colorScheme.outline,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'No Departments Assigned',
                textAlign:
                TextAlign.center,
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                'This supervisor has no assigned departments.',
                textAlign:
                TextAlign.center,
                style: theme
                    .textTheme
                    .bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children:
      _departments.map(
            (department) {
          return Padding(
            padding:
            const EdgeInsets.only(
              bottom: 10,
            ),
            child:
            _buildDepartmentCard(
              theme:
              theme,
              department:
              department,
            ),
          );
        },
      ).toList(),
    );
  }

  // ==========================================================================
  // DEPARTMENT CARD
  // ==========================================================================

  Widget _buildDepartmentCard({
    required ThemeData theme,
    required Map<String, dynamic> department,
  }) {
    final String departmentName =
        department['department_name']
            ?.toString()
            .trim() ??
            'Department';

    final String departmentCode =
        department['department_code']
            ?.toString()
            .trim() ??
            '';

    final String departmentId =
        department['id']
            ?.toString()
            .trim() ??
            '';

    return Card(
      elevation: 0,
      clipBehavior:
      Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _onDepartmentSelected(
            department,
          );
        },
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                child: Icon(
                  Icons
                      .account_tree_outlined,
                  color:
                  theme.colorScheme.primary,
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      departmentName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    if (departmentCode
                        .isNotEmpty) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        departmentCode,
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .primary,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ],
                    if (departmentId
                        .isNotEmpty) ...[
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        'ID: $departmentId',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(
                Icons.chevron_right,
                color: theme
                    .colorScheme
                    .outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // DEPARTMENT SELECTED
  // ==========================================================================

  void _onDepartmentSelected(
      Map<String, dynamic> department) {
    final String departmentId =
        department['id']
            ?.toString()
            .trim() ??
            '';

    final String departmentName =
        department['department_name']
            ?.toString()
            .trim() ??
            'Department';

    debugPrint('');

    debugPrint(
      '============================================================',
    );

    debugPrint(
      'DEPARTMENT SELECTED',
    );

    debugPrint(
      '============================================================',
    );

    debugPrint(
      '[DepartmentPage] Department Name: '
          '$departmentName',
    );

    debugPrint(
      '[DepartmentPage] Department ID: '
          '$departmentId',
    );

    debugPrint(
      '[DepartmentPage] Supervisor ID: '
          '${department['supervisor_id'] ?? ''}',
    );

    debugPrint(
      '[DepartmentPage] Selected Supervisor: '
          '${_selectedSupervisorName ?? ''}',
    );

    debugPrint(
      '============================================================',
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '$departmentName selected',
        ),
        behavior:
        SnackBarBehavior.floating,
      ),
    );

    // ========================================================================
    // NEXT ATTENDANCE FILTER
    //
    // Selected departmentId will be used for:
    //
    // mobile attendance report
    //
    // department_id = selected departmentId
    //
    // Supervisor relation remains:
    //
    // supervisor.id
    //        ↓
    // supervisor_departments.supervisor_id
    //        ↓
    // department_id
    //
    // ========================================================================
  }

  // ==========================================================================
  // SUPERVISOR CARD
  // ==========================================================================

  Widget _buildSupervisorCard({
    required ThemeData theme,
    required Map<String, dynamic> supervisor,
    required String supervisorName,
    required String supervisorCode,
    required String departmentId,
    required bool isSelected,
  }) {
    return Card(
      elevation: 0,
      clipBehavior:
      Clip.antiAlias,
      color: isSelected
          ? theme
          .colorScheme
          .primaryContainer
          : null,
      child: InkWell(
        onTap: () {
          _onSupervisorSelected(
            supervisor,
          );
        },
        child: Padding(
          padding:
          const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =================================================================
              // AVATAR
              // =================================================================

              CircleAvatar(
                radius: 26,
                child: Text(
                  _getInitials(
                    supervisorName,
                  ),
                  style: theme
                      .textTheme
                      .titleMedium,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              // =================================================================
              // INFORMATION
              // =================================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      supervisorName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      'Supervisor ID: '
                          '${supervisor['id'] ?? ''}',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: theme
                            .colorScheme
                            .outline,
                      ),
                    ),

                    if (supervisorCode
                        .isNotEmpty) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        supervisorCode,
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .primary,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ],

                    if (departmentId
                        .isNotEmpty) ...[
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons
                                .business_outlined,
                            size: 15,
                            color: theme
                                .colorScheme
                                .outline,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Department assigned',
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: theme
                                  .colorScheme
                                  .outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              // =================================================================
              // SELECTED INDICATOR
              // =================================================================

              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme
                      .colorScheme
                      .primary,
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: theme
                      .colorScheme
                      .outline,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // ERROR STATE
  // ==========================================================================

  Widget _buildErrorState(
      ThemeData theme) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 80,
        ),
        Icon(
          Icons.error_outline,
          size: 64,
          color:
          theme.colorScheme.error,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Unable to load supervisors',
          textAlign:
          TextAlign.center,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          _supervisorError ??
              'Something went wrong.',
          textAlign:
          TextAlign.center,
          style:
          theme.textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 24,
        ),
        Center(
          child:
          FilledButton.icon(
            onPressed:
            _loadSupervisors,
            icon:
            const Icon(
              Icons.refresh,
            ),
            label:
            const Text(
              'Try Again',
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // EMPTY STATE
  // ==========================================================================

  Widget _buildEmptyState(
      ThemeData theme) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 100,
        ),
        Icon(
          Icons
              .supervisor_account_outlined,
          size: 72,
          color:
          theme.colorScheme.outline,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'No Active Supervisors',
          textAlign:
          TextAlign.center,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          'No active supervisors were found for this company.',
          textAlign:
          TextAlign.center,
          style:
          theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  // ==========================================================================
  // INITIALS
  // ==========================================================================

  String _getInitials(
      String name) {
    final String trimmedName =
    name.trim();

    if (trimmedName.isEmpty) {
      return 'S';
    }

    final List<String> parts =
    trimmedName.split(
      RegExp(r'\s+'),
    );

    if (parts.length == 1) {
      final String first =
          parts.first;

      if (first.length == 1) {
        return first.toUpperCase();
      }

      return first
          .substring(
        0,
        2,
      )
          .toUpperCase();
    }

    final String first =
    parts.first.isNotEmpty
        ? parts.first[0]
        : '';

    final String last =
    parts.last.isNotEmpty
        ? parts.last[0]
        : '';

    final String initials =
    '$first$last'.trim();

    if (initials.isEmpty) {
      return 'S';
    }

    return initials.toUpperCase();
  }
}