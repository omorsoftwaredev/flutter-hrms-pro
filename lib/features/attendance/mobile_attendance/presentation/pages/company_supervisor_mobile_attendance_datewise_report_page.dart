// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Mobile Attendance Report Page
//
// Purpose:
// - Load active supervisors for a company
// - Read supervisor name from employees.full_name
// - Select supervisor
// - Load assigned departments
// - Load employees from selected department
// - Select employee
// - Select From Date / To Date
// - Generate datewise attendance report
// - Open separate datewise report page
//
// Architecture:
// - Clean Architecture
// - Riverpod
// - Material 3
//
// Flow:
//
// Supervisor
//     ↓
// Department
//     ↓
// Employee
//     ↓
// From Date / To Date
//     ↓
// Generate Report
//     ↓
// Separate Datewise Report Page
//
// Important:
// - No popup/dialog is used for datewise configuration.
// - Department can always be changed.
// - Employee list changes according to selected department.
// - Supervisor change clears department and employee.
// - Department change clears employee.
// - Async department/employee requests are protected against stale responses.
//
// Version : 10.0.0
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_hrms_pro/features/attendance/mobile_attendance/presentation/pages/datewise_details_attendance_report_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/supervisor_mobile_attendance_report_provider.dart';

// ============================================================================
// PAGE
// ============================================================================

class CompanySupervisorMobileAttendanceDatewiseReportPage
    extends ConsumerStatefulWidget {
  const CompanySupervisorMobileAttendanceDatewiseReportPage({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  ConsumerState<CompanySupervisorMobileAttendanceDatewiseReportPage> createState() =>
      _CompanySupervisorMobileAttendanceReportPageState();
}

// ============================================================================
// STATE
// ============================================================================

class _CompanySupervisorMobileAttendanceReportPageState
    extends ConsumerState<CompanySupervisorMobileAttendanceDatewiseReportPage> {
  // ==========================================================================
  // SUPABASE
  // ==========================================================================

  final SupabaseClient _supabase = Supabase.instance.client;

  // ==========================================================================
  // SUPERVISOR
  // ==========================================================================

  bool _isLoadingSupervisors = false;

  String? _supervisorError;

  List<Map<String, dynamic>> _supervisors = [];

  String? _selectedSupervisorId;

  String? _selectedSupervisorName;

  // ==========================================================================
  // DEPARTMENT
  // ==========================================================================

  bool _isLoadingDepartments = false;

  String? _departmentError;

  List<Map<String, dynamic>> _departments = [];

  String? _selectedDepartmentId;

  String? _selectedDepartmentName;

  // ==========================================================================
  // EMPLOYEE
  // ==========================================================================

  bool _isLoadingEmployees = false;

  String? _employeeError;

  List<Map<String, dynamic>> _employees = [];

  String? _selectedEmployeeId;

  String? _selectedEmployeeName;

  // ==========================================================================
  // DATE RANGE
  // ==========================================================================

  DateTime? _fromDate;

  DateTime? _toDate;

  // ==========================================================================
  // REPORT
  // ==========================================================================

  bool _isGeneratingReport = false;

  // ==========================================================================
  // ASYNC REQUEST VERSION
  // ==========================================================================

  int _departmentRequestVersion = 0;

  int _employeeRequestVersion = 0;

  // ==========================================================================
  // COMPANY
  // ==========================================================================

  String get companyId => widget.companyId.trim();

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _configureCompany();

      _loadSupervisors();
    });
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _departmentRequestVersion++;
    _employeeRequestVersion++;

    super.dispose();
  }

  // ==========================================================================
  // CONFIGURE COMPANY
  // ==========================================================================

  void _configureCompany() {
    final provider = ref.read(
      supervisorMobileAttendanceReportProvider,
    );

    provider.setCompanyId(companyId);
  }

  // ==========================================================================
  // LOAD SUPERVISORS
  // ==========================================================================

  Future<void> _loadSupervisors() async {
    final String normalizedCompanyId = companyId;

    if (normalizedCompanyId.isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingSupervisors = false;

        _supervisorError = 'Company ID is required.';

        _supervisors = [];

        _selectedSupervisorId = null;
        _selectedSupervisorName = null;

        _departments = [];
        _selectedDepartmentId = null;
        _selectedDepartmentName = null;

        _employees = [];
        _selectedEmployeeId = null;
        _selectedEmployeeName = null;

        _departmentError = null;
        _employeeError = null;

        _fromDate = null;
        _toDate = null;

        _isGeneratingReport = false;
      });

      return;
    }

    _departmentRequestVersion++;
    _employeeRequestVersion++;

    if (mounted) {
      setState(() {
        _isLoadingSupervisors = true;

        _supervisorError = null;

        _supervisors = [];

        _selectedSupervisorId = null;
        _selectedSupervisorName = null;

        _departments = [];
        _selectedDepartmentId = null;
        _selectedDepartmentName = null;

        _employees = [];
        _selectedEmployeeId = null;
        _selectedEmployeeName = null;

        _departmentError = null;
        _employeeError = null;

        _fromDate = null;
        _toDate = null;

        _isGeneratingReport = false;
      });
    }

    try {
      final List<dynamic> response = await _supabase
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
        normalizedCompanyId,
      )
          .eq(
        'is_active',
        true,
      )
          .order(
        'created_at',
        ascending: true,
      );

      final List<Map<String, dynamic>> supervisors = [];

      final Set<String> supervisorIds = {};

      for (final dynamic item in response) {
        if (item is! Map) {
          continue;
        }

        final Map<String, dynamic> supervisor =
        Map<String, dynamic>.from(item);

        final String supervisorId =
            supervisor['id']?.toString().trim() ?? '';

        if (supervisorId.isEmpty) {
          continue;
        }

        if (!supervisorIds.add(supervisorId)) {
          continue;
        }

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
        } else if (employeeData is List &&
            employeeData.isNotEmpty) {
          final dynamic firstEmployee =
              employeeData.first;

          if (firstEmployee is Map) {
            final String employeeName =
                firstEmployee['full_name']
                    ?.toString()
                    .trim() ??
                    '';

            if (employeeName.isNotEmpty) {
              supervisorName = employeeName;
            }
          }
        }

        supervisor['supervisor_name'] =
            supervisorName;

        supervisors.add(supervisor);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _supervisors = supervisors;

        _isLoadingSupervisors = false;

        _supervisorError = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingSupervisors = false;

        _supervisors = [];

        _supervisorError = _cleanError(e);
      });
    }
  }

  // ==========================================================================
  // LOAD DEPARTMENTS
  // ==========================================================================

  Future<void> _loadDepartmentsForSupervisor(
      String supervisorId,
      ) async {
    final String normalizedSupervisorId =
    supervisorId.trim();

    if (normalizedSupervisorId.isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingDepartments = false;

        _departments = [];

        _departmentError =
        'Supervisor is required.';

        _selectedDepartmentId = null;
        _selectedDepartmentName = null;

        _employees = [];

        _selectedEmployeeId = null;
        _selectedEmployeeName = null;

        _employeeError = null;
      });

      return;
    }

    final int requestVersion =
    ++_departmentRequestVersion;

    _employeeRequestVersion++;

    if (mounted) {
      setState(() {
        _isLoadingDepartments = true;

        _departmentError = null;

        _departments = [];

        _selectedDepartmentId = null;
        _selectedDepartmentName = null;

        _employees = [];

        _selectedEmployeeId = null;
        _selectedEmployeeName = null;

        _employeeError = null;
      });
    }

    try {
      final List<dynamic> assignments =
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
        'company_id',
        companyId,
      )
          .eq(
        'supervisor_id',
        normalizedSupervisorId,
      )
          .order(
        'created_at',
        ascending: true,
      );

      if (requestVersion !=
          _departmentRequestVersion) {
        return;
      }

      if (assignments.isEmpty) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isLoadingDepartments = false;

          _departments = [];

          _departmentError = null;
        });

        return;
      }

      final List<Map<String, dynamic>>
      departments = [];

      final Set<String> departmentIds = {};

      for (final dynamic item in assignments) {
        if (requestVersion !=
            _departmentRequestVersion) {
          return;
        }

        if (item is! Map) {
          continue;
        }

        final Map<String, dynamic> assignment =
        Map<String, dynamic>.from(item);

        final String departmentId =
            assignment['department_id']
                ?.toString()
                .trim() ??
                '';

        final String assignmentCompanyId =
            assignment['company_id']
                ?.toString()
                .trim() ??
                '';

        if (departmentId.isEmpty) {
          continue;
        }

        if (!departmentIds.add(
          departmentId,
        )) {
          continue;
        }

        if (assignmentCompanyId.isNotEmpty &&
            assignmentCompanyId !=
                companyId) {
          continue;
        }

        final Map<String, dynamic>?
        departmentResponse =
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
            .eq(
          'company_id',
          companyId,
        )
            .maybeSingle();

        if (requestVersion !=
            _departmentRequestVersion) {
          return;
        }

        if (departmentResponse == null) {
          continue;
        }

        final Map<String, dynamic> department =
        Map<String, dynamic>.from(
          departmentResponse,
        );

        final String departmentCompanyId =
            department['company_id']
                ?.toString()
                .trim() ??
                '';

        if (departmentCompanyId.isNotEmpty &&
            departmentCompanyId !=
                companyId) {
          continue;
        }

        if (department['is_active'] == false) {
          continue;
        }

        department['assignment_id'] =
        assignment['id'];

        department['supervisor_id'] =
            normalizedSupervisorId;

        departments.add(department);
      }

      if (!mounted) {
        return;
      }

      if (requestVersion !=
          _departmentRequestVersion) {
        return;
      }

      setState(() {
        _departments = departments;

        _isLoadingDepartments = false;

        _departmentError = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      if (requestVersion !=
          _departmentRequestVersion) {
        return;
      }

      setState(() {
        _isLoadingDepartments = false;

        _departments = [];

        _departmentError = _cleanError(e);

        _selectedDepartmentId = null;
        _selectedDepartmentName = null;

        _employees = [];

        _selectedEmployeeId = null;
        _selectedEmployeeName = null;

        _employeeError = null;
      });
    }
  }

  // ==========================================================================
  // LOAD EMPLOYEES
  // ==========================================================================

  Future<void> _loadEmployeesForDepartment(
      String departmentId,
      ) async {
    final String normalizedDepartmentId =
    departmentId.trim();

    if (normalizedDepartmentId.isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingEmployees = false;

        _employees = [];

        _employeeError =
        'Department is required.';

        _selectedEmployeeId = null;
        _selectedEmployeeName = null;
      });

      return;
    }

    final int requestVersion =
    ++_employeeRequestVersion;

    if (mounted) {
      setState(() {
        _isLoadingEmployees = true;

        _employeeError = null;

        _employees = [];

        _selectedEmployeeId = null;
        _selectedEmployeeName = null;
      });
    }

    try {
      final List<dynamic> response =
      await _supabase
          .from('employees')
          .select('''
                id,
                company_id,
                department_id,
                employee_code,
                full_name,             
                is_active,
                created_at,
                updated_at
              ''')
          .eq(
        'company_id',
        companyId,
      )
          .eq(
        'department_id',
        normalizedDepartmentId,
      )
          .eq(
        'is_active',
        true,
      )
          .order(
        'full_name',
        ascending: true,
      );

      if (requestVersion !=
          _employeeRequestVersion) {
        return;
      }

      final List<Map<String, dynamic>>
      employees = [];

      final Set<String> employeeIds = {};

      for (final dynamic item in response) {
        if (requestVersion !=
            _employeeRequestVersion) {
          return;
        }

        if (item is! Map) {
          continue;
        }

        final Map<String, dynamic> employee =
        Map<String, dynamic>.from(item);

        final String employeeId =
            employee['id']?.toString().trim() ??
                '';

        final String employeeName =
            employee['full_name']
                ?.toString()
                .trim() ??
                '';

        if (employeeId.isEmpty ||
            employeeName.isEmpty) {
          continue;
        }

        if (!employeeIds.add(employeeId)) {
          continue;
        }

        employees.add(employee);
      }

      if (!mounted) {
        return;
      }

      if (requestVersion !=
          _employeeRequestVersion) {
        return;
      }

      setState(() {
        _employees = employees;

        _isLoadingEmployees = false;

        _employeeError = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      if (requestVersion !=
          _employeeRequestVersion) {
        return;
      }

      setState(() {
        _isLoadingEmployees = false;

        _employees = [];

        _employeeError = _cleanError(e);

        _selectedEmployeeId = null;
        _selectedEmployeeName = null;
      });
    }
  }

  // ==========================================================================
  // SUPERVISOR SELECTED
  // ==========================================================================

  Future<void> _onSupervisorSelected(
      String? supervisorId,
      ) async {
    if (supervisorId == null ||
        supervisorId.trim().isEmpty) {
      return;
    }

    final String normalizedSupervisorId =
    supervisorId.trim();

    Map<String, dynamic>? selectedSupervisor;

    for (final Map<String, dynamic> supervisor
    in _supervisors) {
      final String id =
          supervisor['id']
              ?.toString()
              .trim() ??
              '';

      if (id == normalizedSupervisorId) {
        selectedSupervisor = supervisor;
        break;
      }
    }

    if (selectedSupervisor == null) {
      return;
    }

    final String supervisorName =
        selectedSupervisor['supervisor_name']
            ?.toString()
            .trim() ??
            'Supervisor';

    _departmentRequestVersion++;
    _employeeRequestVersion++;

    final reportProvider = ref.read(
      supervisorMobileAttendanceReportProvider,
    );

    reportProvider.setCompanyId(
      companyId,
    );

    reportProvider.setSupervisorId(
      normalizedSupervisorId,
    );

    reportProvider.setDepartmentId(
      null,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSupervisorId =
          normalizedSupervisorId;

      _selectedSupervisorName =
          supervisorName;

      _selectedDepartmentId = null;
      _selectedDepartmentName = null;

      _departments = [];

      _selectedEmployeeId = null;
      _selectedEmployeeName = null;

      _employees = [];

      _departmentError = null;
      _employeeError = null;

      _fromDate = null;
      _toDate = null;
    });

    await _loadDepartmentsForSupervisor(
      normalizedSupervisorId,
    );
  }

  // ==========================================================================
  // DEPARTMENT SELECTED
  // ==========================================================================

  Future<void> _onDepartmentSelected(
      String? departmentId,
      ) async {
    if (departmentId == null ||
        departmentId.trim().isEmpty) {
      return;
    }

    final String normalizedDepartmentId =
    departmentId.trim();

    Map<String, dynamic>? selectedDepartment;

    for (final Map<String, dynamic> department
    in _departments) {
      final String id =
          department['id']
              ?.toString()
              .trim() ??
              '';

      if (id == normalizedDepartmentId) {
        selectedDepartment = department;
        break;
      }
    }

    if (selectedDepartment == null) {
      return;
    }

    final String departmentName =
        selectedDepartment['name']
            ?.toString()
            .trim() ??
            'Department';

    final reportProvider = ref.read(
      supervisorMobileAttendanceReportProvider,
    );

    reportProvider.setCompanyId(
      companyId,
    );

    if (_selectedSupervisorId != null &&
        _selectedSupervisorId!
            .trim()
            .isNotEmpty) {
      reportProvider.setSupervisorId(
        _selectedSupervisorId!.trim(),
      );
    }

    reportProvider.setDepartmentId(
      normalizedDepartmentId,
    );

    _employeeRequestVersion++;

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedDepartmentId =
          normalizedDepartmentId;

      _selectedDepartmentName =
          departmentName;

      _employees = [];

      _selectedEmployeeId = null;
      _selectedEmployeeName = null;

      _employeeError = null;

      _fromDate = null;
      _toDate = null;
    });

    await _loadEmployeesForDepartment(
      normalizedDepartmentId,
    );
  }

  // ==========================================================================
  // EMPLOYEE SELECTED
  // ==========================================================================

  void _onEmployeeSelected(
      String? employeeId,
      ) {
    if (employeeId == null ||
        employeeId.trim().isEmpty) {
      return;
    }

    final String normalizedEmployeeId =
    employeeId.trim();

    Map<String, dynamic>? selectedEmployee;

    for (final Map<String, dynamic> employee
    in _employees) {
      final String id =
          employee['id']
              ?.toString()
              .trim() ??
              '';

      if (id == normalizedEmployeeId) {
        selectedEmployee = employee;
        break;
      }
    }

    if (selectedEmployee == null) {
      return;
    }

    final String employeeName =
        selectedEmployee['full_name']
            ?.toString()
            .trim() ??
            'Employee';

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedEmployeeId =
          normalizedEmployeeId;

      _selectedEmployeeName =
          employeeName;

      _fromDate = null;
      _toDate = null;
    });
  }

  // ==========================================================================
  // FROM DATE
  // ==========================================================================

  Future<void> _selectFromDate() async {
    if (_selectedEmployeeId == null) {
      _showSnackBar(
        'Please select an employee first.',
        isError: true,
      );

      return;
    }

    final DateTime now = DateTime.now();

    final DateTime firstDate =
    DateTime(
      now.year - 5,
      1,
      1,
    );

    final DateTime lastDate =
    DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime initialDate =
        _fromDate ??
            _toDate ??
            lastDate;

    final DateTime? selected =
    await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(
        firstDate,
      )
          ? firstDate
          : initialDate.isAfter(
        lastDate,
      )
          ? lastDate
          : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select From Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _fromDate = DateTime(
        selected.year,
        selected.month,
        selected.day,
      );

      if (_toDate != null &&
          _toDate!.isBefore(_fromDate!)) {
        _toDate = null;
      }
    });
  }

  // ==========================================================================
  // TO DATE
  // ==========================================================================

  Future<void> _selectToDate() async {
    if (_selectedEmployeeId == null) {
      _showSnackBar(
        'Please select an employee first.',
        isError: true,
      );

      return;
    }

    if (_fromDate == null) {
      _showSnackBar(
        'Please select From Date first.',
        isError: true,
      );

      return;
    }

    final DateTime now = DateTime.now();

    final DateTime firstDate =
    DateTime(
      _fromDate!.year,
      _fromDate!.month,
      _fromDate!.day,
    );

    final DateTime lastDate =
    DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime initialDate =
        _toDate ??
            _fromDate!;

    final DateTime? selected =
    await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(
        firstDate,
      )
          ? firstDate
          : initialDate.isAfter(
        lastDate,
      )
          ? lastDate
          : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select To Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _toDate = DateTime(
        selected.year,
        selected.month,
        selected.day,
      );
    });
  }

  // ==========================================================================
  // GENERATE DATEWISE REPORT
  // ==========================================================================

  Future<void> _generateDatewiseReport() async {
    if (_isGeneratingReport) {
      return;
    }

    if (_selectedSupervisorId == null ||
        _selectedSupervisorId!
            .trim()
            .isEmpty) {
      _showSnackBar(
        'Please select a supervisor.',
        isError: true,
      );

      return;
    }

    if (_selectedDepartmentId == null ||
        _selectedDepartmentId!
            .trim()
            .isEmpty) {
      _showSnackBar(
        'Please select a department.',
        isError: true,
      );

      return;
    }

    if (_selectedEmployeeId == null ||
        _selectedEmployeeId!
            .trim()
            .isEmpty) {
      _showSnackBar(
        'Please select an employee.',
        isError: true,
      );

      return;
    }

    if (_fromDate == null) {
      _showSnackBar(
        'Please select From Date.',
        isError: true,
      );

      return;
    }

    if (_toDate == null) {
      _showSnackBar(
        'Please select To Date.',
        isError: true,
      );

      return;
    }

    if (_toDate!.isBefore(_fromDate!)) {
      _showSnackBar(
        'To Date cannot be earlier than From Date.',
        isError: true,
      );

      return;
    }

    final String supervisorId =
    _selectedSupervisorId!.trim();

    final String supervisorName =
        _selectedSupervisorName ??
            'Supervisor';

    final String departmentId =
    _selectedDepartmentId!.trim();

    final String departmentName =
        _selectedDepartmentName ??
            'Department';

    final String employeeId =
    _selectedEmployeeId!.trim();

    final String employeeName =
        _selectedEmployeeName ??
            'Employee';

    final DateTime fromDate =
    _fromDate!;

    final DateTime toDate =
    _toDate!;

    final provider = ref.read(
      supervisorMobileAttendanceReportProvider,
    );

    if (mounted) {
      setState(() {
        _isGeneratingReport = true;
      });
    }

    try {
      provider.setCompanyId(
        companyId,
      );

      provider.setSupervisorId(
        supervisorId,
      );

      provider.setDepartmentId(
        departmentId,
      );

      // --------------------------------------------------------------
      // Open separate datewise report page.
      //
      // The actual datewise data loading remains inside the report page.
      // --------------------------------------------------------------

      if (!mounted) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              DatewiseDetailsAttendanceReportPage(
                companyId: companyId,
                supervisorId: supervisorId,
                supervisorName: supervisorName,
                departmentId: departmentId,
                departmentName: departmentName,
                employeeId: employeeId,
                employeeName: employeeName,
                fromDate: fromDate,
                toDate: toDate,
              ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showSnackBar(
        _cleanError(e),
        isError: true,
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isGeneratingReport = false;
      });
    }
  }

  // ==========================================================================
  // REFRESH
  // ==========================================================================

  Future<void> _refresh() async {
    if (_isLoadingSupervisors ||
        _isGeneratingReport) {
      return;
    }

    await _loadSupervisors();
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
          'Datewise Report',
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
            _isLoadingSupervisors
                ? null
                : _refresh,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(theme),
      ),
    );
  }

  // ==========================================================================
  // BODY
  // ==========================================================================

  Widget _buildBody(
      ThemeData theme,
      ) {
    if (_isLoadingSupervisors) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_supervisorError != null) {
      return _buildError(
        theme,
        _supervisorError!,
        _loadSupervisors,
      );
    }

    if (_supervisors.isEmpty) {
      return _buildEmpty(
        theme,
        icon:
        Icons.supervisor_account_outlined,
        title: 'No supervisors',
        message:
        'No active supervisors found for this company.',
      );
    }

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final bool isWide =
            constraints.maxWidth >= 700;

        final double contentWidth =
        isWide
            ? 650
            : constraints.maxWidth;

        return ListView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding:
          EdgeInsets.symmetric(
            horizontal:
            isWide ? 24 : 12,
            vertical: 18,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints:
                BoxConstraints(
                  maxWidth:
                  contentWidth,
                ),
                child:
                _buildSelectorContent(
                  theme,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================================
  // SELECTOR CONTENT
  // ==========================================================================

  Widget _buildSelectorContent(
      ThemeData theme,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(theme),

        const SizedBox(
          height: 14,
        ),

        // --------------------------------------------------------------
        // 1. SUPERVISOR
        // --------------------------------------------------------------

        _buildSupervisorDropdown(theme),

        const SizedBox(
          height: 10,
        ),

        // --------------------------------------------------------------
        // 2. DEPARTMENT
        // --------------------------------------------------------------

        _buildDepartmentDropdown(theme),

        // --------------------------------------------------------------
        // 3. EMPLOYEE
        // --------------------------------------------------------------

        if (_selectedDepartmentId != null) ...[
          const SizedBox(
            height: 10,
          ),
          _buildEmployeeDropdown(theme),
        ],

        // --------------------------------------------------------------
        // 4. DATE RANGE
        // --------------------------------------------------------------

        if (_selectedEmployeeId != null) ...[
          const SizedBox(
            height: 16,
          ),
          _buildDateRangeSection(theme),

          const SizedBox(
            height: 16,
          ),

          // ------------------------------------------------------------
          // 5. GENERATE
          // ------------------------------------------------------------

          _buildGenerateButton(theme),
        ],
      ],
    );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeaderCard(
      ThemeData theme,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(18),
        color: theme
            .colorScheme
            .primaryContainer
            .withValues(
          alpha: 0.45,
        ),
        border: Border.all(
          color: theme
              .colorScheme
              .primary
              .withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration:
            BoxDecoration(
              borderRadius:
              BorderRadius.circular(
                14,
              ),
              color: theme
                  .colorScheme
                  .primary,
            ),
            child: Icon(
              Icons.assignment_rounded,
              color: theme
                  .colorScheme
                  .onPrimary,
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
                  'Supervisor Attendance',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Select supervisor, department, employee and date range',
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SUPERVISOR DROPDOWN
  // ==========================================================================

  Widget _buildSupervisorDropdown(
      ThemeData theme,
      ) {
    final String? selectedValue =
    _supervisors.any(
          (item) =>
      item['id']
          ?.toString()
          .trim() ==
          _selectedSupervisorId,
    )
        ? _selectedSupervisorId
        : null;

    return Container(
      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: theme
              .colorScheme
              .outlineVariant,
        ),
        color:
        theme.colorScheme.surface,
      ),
      child:
      DropdownButtonFormField<String>(
        key: ValueKey<String?>(
          'supervisor-$_selectedSupervisorId',
        ),
        value: selectedValue,
        isExpanded: true,
        decoration:
        const InputDecoration(
          labelText:
          'Select Supervisor',
          prefixIcon: Icon(
            Icons.person_outline_rounded,
          ),
          border:
          InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
        icon: const Padding(
          padding:
          EdgeInsets.only(
            right: 10,
          ),
          child: Icon(
            Icons
                .keyboard_arrow_down_rounded,
          ),
        ),
        items: _supervisors.map(
              (supervisor) {
            final String id =
                supervisor['id']
                    ?.toString()
                    .trim() ??
                    '';

            final String name =
                supervisor[
                'supervisor_name']
                    ?.toString()
                    .trim() ??
                    'Supervisor';

            final String code =
                supervisor[
                'supervisors_code']
                    ?.toString()
                    .trim() ??
                    '';

            return DropdownMenuItem<String>(
              value: id,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    child: Text(
                      _getInitials(
                        name,
                      ),
                      style: theme
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      code.isEmpty
                          ? name
                          : '$name • $code',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
        onChanged:
        _isGeneratingReport
            ? null
            : _onSupervisorSelected,
      ),
    );
  }

  // ==========================================================================
  // DEPARTMENT DROPDOWN
  // ==========================================================================

  Widget _buildDepartmentDropdown(
      ThemeData theme,
      ) {
    if (_selectedSupervisorId == null) {
      return _buildDisabledSelector(
        theme,
        label:
        'Select Department',
        icon:
        Icons.account_tree_outlined,
        message:
        'Select Supervisor first',
      );
    }

    if (_isLoadingDepartments) {
      return _buildLoadingSelector(
        theme,
        label:
        'Loading Departments...',
      );
    }

    if (_departmentError != null) {
      return _buildErrorSelector(
        theme,
        message:
        _departmentError!,
        onRetry:
        _selectedSupervisorId ==
            null
            ? null
            : () {
          _loadDepartmentsForSupervisor(
            _selectedSupervisorId!,
          );
        },
      );
    }

    if (_departments.isEmpty) {
      return _buildDisabledSelector(
        theme,
        label:
        'Select Department',
        icon:
        Icons.account_tree_outlined,
        message:
        'No assigned departments',
      );
    }

    final String? selectedValue =
    _departments.any(
          (item) =>
      item['id']
          ?.toString()
          .trim() ==
          _selectedDepartmentId,
    )
        ? _selectedDepartmentId
        : null;

    return Container(
      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color:
          _selectedDepartmentId !=
              null
              ? theme
              .colorScheme
              .primary
              .withValues(
            alpha: 0.45,
          )
              : theme
              .colorScheme
              .outlineVariant,
        ),
        color:
        theme.colorScheme.surface,
      ),
      child:
      DropdownButtonFormField<String>(
        key: ValueKey<String?>(
          'department-'
              '$_selectedSupervisorId-'
              '$_selectedDepartmentId',
        ),
        value: selectedValue,
        isExpanded: true,
        decoration:
        InputDecoration(
          labelText:
          'Select Department',
          helperMaxLines: 1,
          prefixIcon: Icon(
            Icons
                .account_tree_outlined,
            color:
            _selectedDepartmentId !=
                null
                ? theme
                .colorScheme
                .primary
                : null,
          ),
          border:
          InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
        ),
        icon: const Padding(
          padding:
          EdgeInsets.only(
            right: 10,
          ),
          child: Icon(
            Icons
                .keyboard_arrow_down_rounded,
          ),
        ),
        items: _departments.map(
              (department) {
            final String id =
                department['id']
                    ?.toString()
                    .trim() ??
                    '';

            final String name =
                department['name']
                    ?.toString()
                    .trim() ??
                    'Department';

            final String code =
                department['code']
                    ?.toString()
                    .trim() ??
                    '';

            return DropdownMenuItem<String>(
              value: id,
              child: Text(
                code.isEmpty
                    ? name
                    : '$name • $code',
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
              ),
            );
          },
        ).toList(),
        onChanged:
        _isGeneratingReport
            ? null
            : (value) {
          _onDepartmentSelected(
            value,
          );
        },
      ),
    );
  }

  // ==========================================================================
  // EMPLOYEE DROPDOWN
  // ==========================================================================

  Widget _buildEmployeeDropdown(
      ThemeData theme,
      ) {
    if (_isLoadingEmployees) {
      return _buildLoadingSelector(
        theme,
        label:
        'Loading Employees...',
      );
    }

    if (_employeeError != null) {
      return _buildErrorSelector(
        theme,
        message:
        _employeeError!,
        onRetry:
        _selectedDepartmentId ==
            null
            ? null
            : () {
          _loadEmployeesForDepartment(
            _selectedDepartmentId!,
          );
        },
      );
    }

    if (_employees.isEmpty) {
      return _buildDisabledSelector(
        theme,
        label:
        'Select Employee',
        icon:
        Icons.badge_outlined,
        message:
        'No active employees found',
      );
    }

    final String? selectedValue =
    _employees.any(
          (item) =>
      item['id']
          ?.toString()
          .trim() ==
          _selectedEmployeeId,
    )
        ? _selectedEmployeeId
        : null;

    return Container(
      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color:
          _selectedEmployeeId !=
              null
              ? theme
              .colorScheme
              .primary
              .withValues(
            alpha: 0.45,
          )
              : theme
              .colorScheme
              .outlineVariant,
        ),
        color:
        theme.colorScheme.surface,
      ),
      child:
      DropdownButtonFormField<String>(
        key: ValueKey<String?>(
          'employee-'
              '$_selectedDepartmentId-'
              '$_selectedEmployeeId',
        ),
        value: selectedValue,
        isExpanded: true,
        decoration:
        InputDecoration(
          labelText:
          'Select Employee',
          prefixIcon: Icon(
            Icons.badge_outlined,
            color:
            _selectedEmployeeId !=
                null
                ? theme
                .colorScheme
                .primary
                : null,
          ),
          border:
          InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
        ),
        icon: const Padding(
          padding:
          EdgeInsets.only(
            right: 10,
          ),
          child: Icon(
            Icons
                .keyboard_arrow_down_rounded,
          ),
        ),
        items: _employees.map(
              (employee) {
            final String id =
                employee['id']
                    ?.toString()
                    .trim() ??
                    '';

            final String name =
                employee['full_name']
                    ?.toString()
                    .trim() ??
                    'Employee';

            final String code =
                employee['employee_code']
                    ?.toString()
                    .trim() ??
                    '';

            final String designation =
                employee['designation_name']
                    ?.toString()
                    .trim() ??
                    '';

            String displayText = name;

            if (code.isNotEmpty) {
              displayText =
              '$name • $code';
            }

            return DropdownMenuItem<String>(
              value: id,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    child: Text(
                      _getInitials(
                        name,
                      ),
                      style: theme
                          .textTheme
                          .labelMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          displayText,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                        ),
                        if (designation
                            .isNotEmpty)
                          Text(
                            designation,
                            maxLines: 1,
                            overflow:
                            TextOverflow
                                .ellipsis,
                            style: theme
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                              color: theme
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
        onChanged:
        _isGeneratingReport
            ? null
            : _onEmployeeSelected,
      ),
    );
  }

  // ==========================================================================
  // DATE RANGE SECTION
  // ==========================================================================

  Widget _buildDateRangeSection(
      ThemeData theme,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: theme
              .colorScheme
              .outlineVariant,
        ),
        color: theme
            .colorScheme
            .surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration:
                BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                  color: theme
                      .colorScheme
                      .primaryContainer,
                ),
                child: Icon(
                  Icons
                      .date_range_rounded,
                  size: 21,
                  color: theme
                      .colorScheme
                      .primary,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      'Date Range',
                      style: theme
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Select the attendance report period',
                      style: theme
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                        color: theme
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          LayoutBuilder(
            builder: (
                context,
                constraints,
                ) {
              final bool isWide =
                  constraints.maxWidth >=
                      450;

              if (isWide) {
                return Row(
                  children: [
                    Expanded(
                      child:
                      _buildDateButton(
                        theme: theme,
                        title:
                        'From Date',
                        date: _fromDate,
                        icon: Icons
                            .calendar_today_rounded,
                        onPressed:
                        _isGeneratingReport
                            ? null
                            : _selectFromDate,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child:
                      _buildDateButton(
                        theme: theme,
                        title:
                        'To Date',
                        date: _toDate,
                        icon: Icons
                            .event_rounded,
                        onPressed:
                        _isGeneratingReport
                            ? null
                            : _selectToDate,
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _buildDateButton(
                    theme: theme,
                    title: 'From Date',
                    date: _fromDate,
                    icon: Icons
                        .calendar_today_rounded,
                    onPressed:
                    _isGeneratingReport
                        ? null
                        : _selectFromDate,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildDateButton(
                    theme: theme,
                    title: 'To Date',
                    date: _toDate,
                    icon:
                    Icons.event_rounded,
                    onPressed:
                    _isGeneratingReport
                        ? null
                        : _selectToDate,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DATE BUTTON
  // ==========================================================================

  Widget _buildDateButton({
    required ThemeData theme,
    required String title,
    required DateTime? date,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final bool hasDate =
        date != null;

    return OutlinedButton(
      onPressed: onPressed,
      style:
      OutlinedButton.styleFrom(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        alignment:
        Alignment.centerLeft,
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
            13,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: hasDate
                ? theme
                .colorScheme
                .primary
                : null,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  title,
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  hasDate
                      ? _formatDate(date)
                      : 'Select date',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    fontWeight:
                    hasDate
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: hasDate
                        ? null
                        : theme
                        .colorScheme
                        .outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Icon(
            Icons
                .keyboard_arrow_down_rounded,
            size: 20,
            color: theme
                .colorScheme
                .outline,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // GENERATE BUTTON
  // ==========================================================================

  Widget _buildGenerateButton(
      ThemeData theme,
      ) {
    final bool enabled =
        _selectedEmployeeId != null &&
            _fromDate != null &&
            _toDate != null &&
            !_isGeneratingReport;

    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed:
        enabled
            ? _generateDatewiseReport
            : null,
        icon: _isGeneratingReport
            ? const SizedBox(
          width: 20,
          height: 20,
          child:
          CircularProgressIndicator(
            strokeWidth: 2.2,
          ),
        )
            : const Icon(
          Icons
              .assessment_rounded,
        ),
        label: Text(
          _isGeneratingReport
              ? 'Opening Report...'
              : 'Generate Report',
        ),
      ),
    );
  }

  // ==========================================================================
  // LOADING SELECTOR
  // ==========================================================================

  Widget _buildLoadingSelector(
      ThemeData theme, {
        required String label,
      }) {
    return Container(
      height: 58,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: theme
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child:
            CircularProgressIndicator(
              strokeWidth: 2.2,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            label,
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: theme
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DISABLED SELECTOR
  // ==========================================================================

  Widget _buildDisabledSelector(
      ThemeData theme, {
        required String label,
        required IconData icon,
        required String message,
      }) {
    return Container(
      height: 58,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: theme
              .colorScheme
              .outlineVariant,
        ),
        color: theme
            .colorScheme
            .surfaceContainerLowest,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
            theme.colorScheme.outline,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .outline,
                  ),
                ),
                Text(
                  message,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons
                .keyboard_arrow_down_rounded,
            color:
            theme.colorScheme.outline,
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // ERROR SELECTOR
  // ==========================================================================

  Widget _buildErrorSelector(
      ThemeData theme, {
        required String message,
        required VoidCallback? onRetry,
      }) {
    return Container(
      constraints:
      const BoxConstraints(
        minHeight: 58,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration:
      BoxDecoration(
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color: theme
              .colorScheme
              .error
              .withValues(
            alpha: 0.35,
          ),
        ),
        color: theme
            .colorScheme
            .errorContainer
            .withValues(
          alpha: 0.25,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons
                .error_outline_rounded,
            size: 21,
            color:
            theme.colorScheme.error,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style:
              theme.textTheme.bodySmall,
            ),
          ),
          if (onRetry != null)
            IconButton(
              visualDensity:
              VisualDensity.compact,
              tooltip: 'Retry',
              onPressed:
              _isLoadingDepartments ||
                  _isLoadingEmployees
                  ? null
                  : onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================================
  // ERROR PAGE
  // ==========================================================================

  Widget _buildError(
      ThemeData theme,
      String message,
      VoidCallback onRetry,
      ) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding:
      const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 90,
        ),
        Icon(
          Icons.error_outline_rounded,
          size: 60,
          color:
          theme.colorScheme.error,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'Unable to load data',
          textAlign:
          TextAlign.center,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          message,
          textAlign:
          TextAlign.center,
          style:
          theme.textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child:
          FilledButton.icon(
            onPressed:
            _isLoadingSupervisors
                ? null
                : onRetry,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'Try Again',
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // EMPTY
  // ==========================================================================

  Widget _buildEmpty(
      ThemeData theme, {
        required IconData icon,
        required String title,
        required String message,
      }) {
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
          icon,
          size: 68,
          color:
          theme.colorScheme.outline,
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          title,
          textAlign:
          TextAlign.center,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          message,
          textAlign:
          TextAlign.center,
          style:
          theme.textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child:
          OutlinedButton.icon(
            onPressed:
            _isLoadingSupervisors
                ? null
                : _refresh,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text(
              'Refresh',
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SNACKBAR
  // ==========================================================================

  void _showSnackBar(
      String message, {
        bool isError = false,
      }) {
    if (!mounted) {
      return;
    }

    final ThemeData theme =
    Theme.of(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
          backgroundColor: isError
              ? theme.colorScheme.error
              : null,
        ),
      );
  }

  // ==========================================================================
  // DATE FORMAT
  // ==========================================================================

  String _formatDate(
      DateTime? date,
      ) {
    if (date == null) {
      return 'Select date';
    }

    final String day =
    date.day.toString().padLeft(
      2,
      '0',
    );

    final String month =
    date.month.toString().padLeft(
      2,
      '0',
    );

    final String year =
    date.year.toString();

    return '$day/$month/$year';
  }

  // ==========================================================================
  // ERROR CLEANER
  // ==========================================================================

  String _cleanError(
      Object error,
      ) {
    String message =
    error.toString().trim();

    if (message.startsWith(
      'Exception: ',
    )) {
      message = message.substring(
        'Exception: '.length,
      );
    }

    if (message.isEmpty) {
      return 'Something went wrong.';
    }

    if (message.contains(
      'PGRST116',
    )) {
      return 'Requested record was not found.';
    }

    if (message.contains(
      'PGRST204',
    )) {
      return 'Required database data is unavailable.';
    }

    if (message.contains(
      '42501',
    )) {
      return 'You do not have permission to access this data.';
    }

    return message;
  }

  // ==========================================================================
  // INITIALS
  // ==========================================================================

  String _getInitials(
      String name,
      ) {
    final String value =
    name.trim();

    if (value.isEmpty) {
      return 'S';
    }

    final List<String> parts =
    value.split(
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

    return initials.isEmpty
        ? 'S'
        : initials.toUpperCase();
  }
}