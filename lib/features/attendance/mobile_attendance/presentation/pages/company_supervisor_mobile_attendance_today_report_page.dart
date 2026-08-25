// ============================================================================
// Flutter HRMS Pro
// Company Supervisor Mobile Attendance Report Page
//
// Purpose:
// - Load active supervisors for a company
// - Read supervisor name from employees.full_name
// - Select supervisor
// - Allow department selection/change at any time
// - Load assigned departments
// - Configure SupervisorMobileAttendanceReportProvider
// - Open Today / Datewise attendance report
//
// Architecture:
// - Clean Architecture
// - Riverpod
// - Material 3
//
// Responsive:
// - Mobile
// - Tablet
// - Desktop
//
// Important Behavior:
// - Department can ALWAYS be changed after selection.
// - Selecting a wrong department does NOT lock the dropdown.
// - Changing department immediately updates the report provider.
// - Supervisor change clears previous department selection.
// - Async department requests are protected against stale responses.
//
// Version : 8.0.0
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_hrms_pro/features/attendance/mobile_attendance/presentation/pages/today_details_attendance_report_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/supervisor_mobile_attendance_report_provider.dart';

// ============================================================================
// PAGE
// ============================================================================

class CompanySupervisorMobileAttendanceTodayReportPage
    extends ConsumerStatefulWidget {
  const CompanySupervisorMobileAttendanceTodayReportPage({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  ConsumerState<CompanySupervisorMobileAttendanceTodayReportPage> createState() =>
      _CompanySupervisorMobileAttendanceReportPageState();
}

// ============================================================================
// STATE
// ============================================================================

class _CompanySupervisorMobileAttendanceReportPageState
    extends ConsumerState<CompanySupervisorMobileAttendanceTodayReportPage> {
  // ==========================================================================
  // SUPABASE
  // ==========================================================================

  final SupabaseClient _supabase = Supabase.instance.client;

  // ==========================================================================
  // SUPERVISOR STATE
  // ==========================================================================

  bool _isLoadingSupervisors = false;

  String? _supervisorError;

  List<Map<String, dynamic>> _supervisors = [];

  String? _selectedSupervisorId;

  String? _selectedSupervisorName;

  // ==========================================================================
  // DEPARTMENT STATE
  // ==========================================================================

  bool _isLoadingDepartments = false;

  String? _departmentError;

  List<Map<String, dynamic>> _departments = [];

  String? _selectedDepartmentId;

  String? _selectedDepartmentName;

  // ==========================================================================
  // REPORT STATE
  // ==========================================================================

  bool _isOpeningReport = false;

  // ==========================================================================
  // ASYNC REQUEST VERSION
  //
  // Prevents an older department request from overwriting a newer request.
  //
  // Example:
  // Supervisor A selected
  // -> departments request A starts
  //
  // Supervisor B selected quickly
  // -> departments request B starts
  //
  // If request A finishes later, it will be ignored.
  // ==========================================================================

  int _departmentRequestVersion = 0;

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

        _selectedDepartmentId = null;
        _selectedDepartmentName = null;

        _departments = [];
        _departmentError = null;
      });

      return;
    }

    // ------------------------------------------------------------------------
    // Invalidate every previous department request.
    // ------------------------------------------------------------------------

    _departmentRequestVersion++;

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

        _departmentError = null;

        _isOpeningReport = false;
      });
    }

    try {
      // ----------------------------------------------------------------------
      // Load active supervisors.
      //
      // Supervisor name comes from:
      // employees.full_name
      // ----------------------------------------------------------------------

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

        // --------------------------------------------------------------------
        // Prevent duplicate supervisor records.
        // --------------------------------------------------------------------

        if (!supervisorIds.add(supervisorId)) {
          continue;
        }

        // --------------------------------------------------------------------
        // Resolve employee name.
        //
        // Supabase relationship may return Map or List.
        // --------------------------------------------------------------------

        final dynamic employeeData = supervisor['employees'];

        String supervisorName = 'Unknown Supervisor';

        if (employeeData is Map) {
          final String employeeName =
              employeeData['full_name']?.toString().trim() ?? '';

          if (employeeName.isNotEmpty) {
            supervisorName = employeeName;
          }
        } else if (employeeData is List && employeeData.isNotEmpty) {
          final dynamic firstEmployee = employeeData.first;

          if (firstEmployee is Map) {
            final String employeeName =
                firstEmployee['full_name']?.toString().trim() ?? '';

            if (employeeName.isNotEmpty) {
              supervisorName = employeeName;
            }
          }
        }

        supervisor['supervisor_name'] = supervisorName;

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
  // LOAD DEPARTMENTS FOR SUPERVISOR
  // ==========================================================================

  Future<void> _loadDepartmentsForSupervisor(
      String supervisorId,
      ) async {
    final String normalizedSupervisorId = supervisorId.trim();

    if (normalizedSupervisorId.isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingDepartments = false;
        _departments = [];
        _departmentError = 'Supervisor is required.';

        _selectedDepartmentId = null;
        _selectedDepartmentName = null;
      });

      return;
    }

    // ------------------------------------------------------------------------
    // Generate new request version.
    // ------------------------------------------------------------------------

    final int requestVersion = ++_departmentRequestVersion;

    if (mounted) {
      setState(() {
        _isLoadingDepartments = true;

        _departmentError = null;

        _departments = [];

        _selectedDepartmentId = null;
        _selectedDepartmentName = null;
      });
    }

    try {
      // ----------------------------------------------------------------------
      // Load supervisor department assignments.
      // ----------------------------------------------------------------------

      final List<dynamic> assignments = await _supabase
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

      // ----------------------------------------------------------------------
      // Ignore stale request.
      // ----------------------------------------------------------------------

      if (requestVersion != _departmentRequestVersion) {
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

      final List<Map<String, dynamic>> departments = [];

      final Set<String> departmentIds = {};

      // ----------------------------------------------------------------------
      // Resolve assigned departments.
      // ----------------------------------------------------------------------

      for (final dynamic item in assignments) {
        if (requestVersion != _departmentRequestVersion) {
          return;
        }

        if (item is! Map) {
          continue;
        }

        final Map<String, dynamic> assignment =
        Map<String, dynamic>.from(item);

        final String departmentId =
            assignment['department_id']?.toString().trim() ?? '';

        final String assignmentCompanyId =
            assignment['company_id']?.toString().trim() ?? '';

        if (departmentId.isEmpty) {
          continue;
        }

        // --------------------------------------------------------------------
        // Prevent duplicate departments.
        // --------------------------------------------------------------------

        if (!departmentIds.add(departmentId)) {
          continue;
        }

        // --------------------------------------------------------------------
        // Defensive company validation.
        // --------------------------------------------------------------------

        if (assignmentCompanyId.isNotEmpty &&
            assignmentCompanyId != companyId) {
          continue;
        }

        // --------------------------------------------------------------------
        // Load department.
        // --------------------------------------------------------------------

        final Map<String, dynamic>? departmentResponse = await _supabase
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

        // --------------------------------------------------------------------
        // Ignore stale request after await.
        // --------------------------------------------------------------------

        if (requestVersion != _departmentRequestVersion) {
          return;
        }

        if (departmentResponse == null) {
          continue;
        }

        final Map<String, dynamic> department =
        Map<String, dynamic>.from(departmentResponse);

        final String departmentCompanyId =
            department['company_id']?.toString().trim() ?? '';

        if (departmentCompanyId.isNotEmpty &&
            departmentCompanyId != companyId) {
          continue;
        }

        if (department['is_active'] == false) {
          continue;
        }

        department['assignment_id'] = assignment['id'];

        department['supervisor_id'] = normalizedSupervisorId;

        departments.add(department);
      }

      if (!mounted) {
        return;
      }

      if (requestVersion != _departmentRequestVersion) {
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

      if (requestVersion != _departmentRequestVersion) {
        return;
      }

      setState(() {
        _isLoadingDepartments = false;
        _departments = [];
        _departmentError = _cleanError(e);

        _selectedDepartmentId = null;
        _selectedDepartmentName = null;
      });
    }
  }

  // ==========================================================================
  // SUPERVISOR SELECTED
  //
  // Selecting a supervisor ALWAYS resets department because the department
  // assignments belong to the selected supervisor.
  // ==========================================================================

  Future<void> _onSupervisorSelected(
      String? supervisorId,
      ) async {
    if (supervisorId == null || supervisorId.trim().isEmpty) {
      return;
    }

    final String normalizedSupervisorId = supervisorId.trim();

    Map<String, dynamic>? selectedSupervisor;

    for (final Map<String, dynamic> supervisor in _supervisors) {
      final String id = supervisor['id']?.toString().trim() ?? '';

      if (id == normalizedSupervisorId) {
        selectedSupervisor = supervisor;
        break;
      }
    }

    if (selectedSupervisor == null) {
      return;
    }

    final String supervisorName =
        selectedSupervisor['supervisor_name']?.toString().trim() ??
            'Supervisor';

    // ------------------------------------------------------------------------
    // Invalidate old department request.
    // ------------------------------------------------------------------------

    _departmentRequestVersion++;

    // ------------------------------------------------------------------------
    // Configure report provider.
    // ------------------------------------------------------------------------

    final reportProvider = ref.read(
      supervisorMobileAttendanceReportProvider,
    );

    reportProvider.setCompanyId(companyId);

    reportProvider.setSupervisorId(normalizedSupervisorId);

    reportProvider.setDepartmentId(null);

    // ------------------------------------------------------------------------
    // Update UI immediately.
    // ------------------------------------------------------------------------

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSupervisorId = normalizedSupervisorId;

      _selectedSupervisorName = supervisorName;

      // Supervisor changed -> old department is no longer valid.
      _selectedDepartmentId = null;

      _selectedDepartmentName = null;

      _departments = [];

      _departmentError = null;
    });

    // ------------------------------------------------------------------------
    // Load new supervisor departments.
    // ------------------------------------------------------------------------

    await _loadDepartmentsForSupervisor(
      normalizedSupervisorId,
    );
  }

  // ==========================================================================
  // DEPARTMENT SELECTED
  //
  // IMPORTANT:
  //
  // This method DOES NOT disable or lock the department dropdown.
  //
  // User can:
  //
  // Department A
  //     ↓
  // Department B
  //     ↓
  // Department C
  //     ↓
  // Department A
  //
  // as many times as required.
  // ==========================================================================

  void _onDepartmentSelected(
      String? departmentId,
      ) {
    if (departmentId == null || departmentId.trim().isEmpty) {
      return;
    }

    final String normalizedDepartmentId = departmentId.trim();

    Map<String, dynamic>? selectedDepartment;

    for (final Map<String, dynamic> department in _departments) {
      final String id = department['id']?.toString().trim() ?? '';

      if (id == normalizedDepartmentId) {
        selectedDepartment = department;
        break;
      }
    }

    if (selectedDepartment == null) {
      return;
    }

    final String departmentName =
        selectedDepartment['name']?.toString().trim() ?? 'Department';

    // ------------------------------------------------------------------------
    // Configure central report provider immediately.
    //
    // This means changing department also changes the report context.
    // ------------------------------------------------------------------------

    final reportProvider = ref.read(
      supervisorMobileAttendanceReportProvider,
    );

    reportProvider.setCompanyId(companyId);

    final String? supervisorId = _selectedSupervisorId;

    if (supervisorId != null && supervisorId.trim().isNotEmpty) {
      reportProvider.setSupervisorId(supervisorId.trim());
    }

    reportProvider.setDepartmentId(normalizedDepartmentId);

    // ------------------------------------------------------------------------
    // Update UI.
    //
    // IMPORTANT:
    // We do NOT remove departments.
    // We do NOT disable dropdown.
    // We do NOT set a lock state.
    // ------------------------------------------------------------------------

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedDepartmentId = normalizedDepartmentId;

      _selectedDepartmentName = departmentName;
    });
  }

  // ==========================================================================
  // CHANGE DEPARTMENT
  //
  // Explicit helper for future UI actions.
  // ==========================================================================

  void _changeDepartment() {
    if (_isOpeningReport) {
      return;
    }

    // The dropdown itself remains active.
    //
    // This method intentionally does not clear the current selection.
    // User can simply open the dropdown and select another department.
  }

  // ==========================================================================
  // CONFIGURE REPORT PROVIDER
  // ==========================================================================

  bool _configureReportProvider() {
    final String normalizedCompanyId = companyId;

    final String? supervisorId = _selectedSupervisorId;

    final String? departmentId = _selectedDepartmentId;

    if (normalizedCompanyId.isEmpty) {
      _showSnackBar(
        'Company ID is required.',
        isError: true,
      );

      return false;
    }

    if (supervisorId == null || supervisorId.trim().isEmpty) {
      _showSnackBar(
        'Please select a supervisor.',
        isError: true,
      );

      return false;
    }

    if (departmentId == null || departmentId.trim().isEmpty) {
      _showSnackBar(
        'Please select a department.',
        isError: true,
      );

      return false;
    }

    final provider = ref.read(
      supervisorMobileAttendanceReportProvider,
    );

    provider.setCompanyId(normalizedCompanyId);

    provider.setSupervisorId(supervisorId.trim());

    provider.setDepartmentId(departmentId.trim());

    return true;
  }

  // ==========================================================================
  // TODAY REPORT
  // ==========================================================================

  Future<void> _openTodayReport() async {
    if (_isOpeningReport) {
      return;
    }

    if (!_configureReportProvider()) {
      return;
    }

    final String supervisorId = _selectedSupervisorId!;

    final String departmentId = _selectedDepartmentId!;

    final String supervisorName =
        _selectedSupervisorName ?? 'Supervisor';

    final String departmentName =
        _selectedDepartmentName ?? 'Department';

    final provider = ref.read(
      supervisorMobileAttendanceReportProvider,
    );

    if (mounted) {
      setState(() {
        _isOpeningReport = true;
      });
    }

    try {
      // ----------------------------------------------------------------------
      // Load today's report.
      // ----------------------------------------------------------------------

      await provider.loadTodayReports(
        companyId: companyId,
        supervisorId: supervisorId,
        departmentId: departmentId,
      );

      if (!mounted) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              TodayDetailsAttendanceReportPage(
                companyId: companyId,
                supervisorId: supervisorId,
                supervisorName: supervisorName,
                departmentId: departmentId,
                departmentName: departmentName,
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
        _isOpeningReport = false;
      });
    }
  }

  // ==========================================================================
  // REFRESH
  // ==========================================================================

  Future<void> _refresh() async {
    if (_isLoadingSupervisors) {
      return;
    }

    await _loadSupervisors();
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today Attendance Report',
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _isLoadingSupervisors ? null : _refresh,
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
        icon: Icons.supervisor_account_outlined,
        title: 'No supervisors',
        message: 'No active supervisors found for this company.',
      );
    }

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final bool isWide = constraints.maxWidth >= 700;

        final double contentWidth =
        isWide ? 650 : constraints.maxWidth;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 24 : 12,
            vertical: 18,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: contentWidth,
                ),
                child: _buildSelectorContent(theme),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderCard(theme),

        const SizedBox(
          height: 14,
        ),

        _buildSupervisorDropdown(theme),

        const SizedBox(
          height: 10,
        ),

        _buildDepartmentDropdown(theme),

        if (_selectedDepartmentId != null) ...[
          const SizedBox(
            height: 8,
          ),

          _buildSelectedDepartmentInfo(theme),

          const SizedBox(
            height: 14,
          ),

          _buildReportActions(theme),
        ],
      ],
    );
  }

  // ==========================================================================
  // HEADER CARD
  // ==========================================================================

  Widget _buildHeaderCard(
      ThemeData theme,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.primaryContainer.withValues(
          alpha: 0.45,
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: theme.colorScheme.primary,
            ),
            child: Icon(
              Icons.assignment_rounded,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Supervisor Attendance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  'Select supervisor and department',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
    final String? selectedValue = _supervisors.any(
          (item) =>
      item['id']?.toString().trim() == _selectedSupervisorId,
    )
        ? _selectedSupervisorId
        : null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        color: theme.colorScheme.surface,
      ),
      child: DropdownButtonFormField<String>(
        key: ValueKey<String?>(
          'supervisor-dropdown-$_selectedSupervisorId',
        ),
        value: selectedValue,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Select Supervisor',
          prefixIcon: Icon(
            Icons.person_outline_rounded,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
        icon: const Padding(
          padding: EdgeInsets.only(
            right: 10,
          ),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
          ),
        ),
        items: _supervisors.map(
              (supervisor) {
            final String id =
                supervisor['id']?.toString().trim() ?? '';

            final String name =
                supervisor['supervisor_name']?.toString().trim() ??
                    'Supervisor';

            final String code =
                supervisor['supervisors_code']?.toString().trim() ??
                    '';

            return DropdownMenuItem<String>(
              value: id,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    child: Text(
                      _getInitials(name),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      code.isEmpty ? name : '$name • $code',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
        onChanged: _isOpeningReport
            ? null
            : _onSupervisorSelected,
      ),
    );
  }

  // ==========================================================================
  // DEPARTMENT DROPDOWN
  //
  // IMPORTANT:
  // This dropdown remains enabled after a department has already been
  // selected.
  //
  // User can change:
  //
  // A -> B
  // B -> C
  // C -> A
  //
  // without any restriction.
  // ==========================================================================

  Widget _buildDepartmentDropdown(
      ThemeData theme,
      ) {
    if (_selectedSupervisorId == null) {
      return _buildDisabledSelector(
        theme,
        label: 'Select Department',
        icon: Icons.account_tree_outlined,
        message: 'Select Supervisor first',
      );
    }

    if (_isLoadingDepartments) {
      return Container(
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
            ),
          ),
        ),
      );
    }

    if (_departmentError != null) {
      return _buildErrorSelector(
        theme,
        message: _departmentError!,
        onRetry: _selectedSupervisorId == null
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
        label: 'Select Department',
        icon: Icons.account_tree_outlined,
        message: 'No assigned departments',
      );
    }

    final String? selectedValue = _departments.any(
          (item) =>
      item['id']?.toString().trim() == _selectedDepartmentId,
    )
        ? _selectedDepartmentId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _selectedDepartmentId != null
                  ? theme.colorScheme.primary.withValues(
                alpha: 0.45,
              )
                  : theme.colorScheme.outlineVariant,
            ),
            color: theme.colorScheme.surface,
          ),
          child: DropdownButtonFormField<String>(
            // ----------------------------------------------------------------
            // IMPORTANT FIX
            //
            // Key changes whenever selected department changes.
            // This prevents DropdownButtonFormField's internal FormField state
            // from keeping an outdated selection.
            // ----------------------------------------------------------------

            key: ValueKey<String?>(
              'department-dropdown-'
                  '$_selectedSupervisorId-'
                  '$_selectedDepartmentId',
            ),

            value: selectedValue,

            isExpanded: true,

            decoration: InputDecoration(
              labelText: 'Select Department',
              helperText: _selectedDepartmentId == null
                  ? null
                  : 'You can change department anytime',
              helperMaxLines: 1,
              prefixIcon: Icon(
                Icons.account_tree_outlined,
                color: _selectedDepartmentId != null
                    ? theme.colorScheme.primary
                    : null,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
            ),

            icon: const Padding(
              padding: EdgeInsets.only(
                right: 10,
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
              ),
            ),

            // ----------------------------------------------------------------
            // ALL ASSIGNED DEPARTMENTS REMAIN AVAILABLE.
            // ----------------------------------------------------------------

            items: _departments.map(
                  (department) {
                final String id =
                    department['id']?.toString().trim() ?? '';

                final String name =
                    department['name']?.toString().trim() ??
                        'Department';

                final String code =
                    department['code']?.toString().trim() ?? '';

                final bool isSelected =
                    id == _selectedDepartmentId;

                return DropdownMenuItem<String>(
                  value: id,
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSelected
                              ? theme.colorScheme.primaryContainer
                              : theme
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        child: Icon(
                          isSelected
                              ? Icons.check_rounded
                              : Icons.account_tree_outlined,
                          size: 19,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          code.isEmpty ? name : '$name • $code',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),

            // ----------------------------------------------------------------
            // IMPORTANT:
            //
            // This is intentionally NOT disabled after department selection.
            //
            // Before:
            // selected -> report -> dropdown effectively behaved locked
            //
            // Now:
            // selected -> dropdown remains enabled -> another department
            // can be selected.
            // ----------------------------------------------------------------

            onChanged: _isOpeningReport
                ? null
                : _onDepartmentSelected,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // SELECTED DEPARTMENT INFO
  //
  // Small visual confirmation that the current report context is using this
  // department.
  // ==========================================================================

  Widget _buildSelectedDepartmentInfo(
      ThemeData theme,
      ) {
    final String departmentName =
        _selectedDepartmentName ?? 'Department';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.secondaryContainer.withValues(
          alpha: 0.45,
        ),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(
            alpha: 0.15,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 19,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              'Selected: $departmentName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          TextButton(
            onPressed: _isOpeningReport
                ? null
                : _changeDepartment,
            style: TextButton.styleFrom(
              minimumSize: const Size(
                0,
                32,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
            ),
            child: const Text(
              'Change',
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // REPORT ACTIONS
  // ==========================================================================

  Widget _buildReportActions(
      ThemeData theme,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _buildReportButton(
            theme: theme,
            icon: Icons.today_rounded,
            title: 'Today',
            subtitle: 'Current attendance',
            onPressed: _isOpeningReport
                ? null
                : _openTodayReport,
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // REPORT BUTTON
  // ==========================================================================

  Widget _buildReportButton({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onPressed,
  }) {
    final bool enabled = onPressed != null;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: enabled
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: enabled
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: enabled
                            ? null
                            : theme.colorScheme.outline,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: enabled
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isOpeningReport)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: enabled
                      ? theme.colorScheme.outline
                      : theme.colorScheme.outlineVariant,
                ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        color: theme.colorScheme.surfaceContainerLowest,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.colorScheme.outline,
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
      constraints: const BoxConstraints(
        minHeight: 58,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.error.withValues(
            alpha: 0.35,
          ),
        ),
        color: theme.colorScheme.errorContainer.withValues(
          alpha: 0.25,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 21,
            color: theme.colorScheme.error,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
          if (onRetry != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Retry',
              onPressed: _isLoadingDepartments
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
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 90,
        ),
        Icon(
          Icons.error_outline_rounded,
          size: 60,
          color: theme.colorScheme.error,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          'Unable to load data',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: FilledButton.icon(
            onPressed: _isLoadingSupervisors
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
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(
          height: 100,
        ),
        Icon(
          icon,
          size: 68,
          color: theme.colorScheme.outline,
        ),
        const SizedBox(
          height: 18,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: OutlinedButton.icon(
            onPressed: _isLoadingSupervisors
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

    final ThemeData theme = Theme.of(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
          isError ? theme.colorScheme.error : null,
        ),
      );
  }

  // ==========================================================================
  // ERROR CLEANER
  // ==========================================================================

  String _cleanError(
      Object error,
      ) {
    String message = error.toString().trim();

    if (message.startsWith('Exception: ')) {
      message = message.substring(
        'Exception: '.length,
      );
    }

    if (message.isEmpty) {
      return 'Something went wrong.';
    }

    // ------------------------------------------------------------------------
    // Common Supabase/PostgREST errors.
    // ------------------------------------------------------------------------

    if (message.contains('PGRST116')) {
      return 'Requested record was not found.';
    }

    if (message.contains('PGRST204')) {
      return 'Required database data is unavailable.';
    }

    if (message.contains('42501')) {
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
    final String value = name.trim();

    if (value.isEmpty) {
      return 'S';
    }

    final List<String> parts = value.split(
      RegExp(r'\s+'),
    );

    if (parts.length == 1) {
      final String first = parts.first;

      if (first.length == 1) {
        return first.toUpperCase();
      }

      return first.substring(0, 2).toUpperCase();
    }

    final String first = parts.first.isNotEmpty
        ? parts.first[0]
        : '';

    final String last = parts.last.isNotEmpty
        ? parts.last[0]
        : '';

    final String initials = '$first$last'.trim();

    return initials.isEmpty
        ? 'S'
        : initials.toUpperCase();
  }
}