/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Assignment Page
///
/// File:
/// supervisor_department_assignment_page.dart
///
/// Version : 3.0.0
///
/// UI:
/// - Professional HRMS Theme
/// - Responsive Desktop
/// - Responsive Tablet
/// - Responsive Mobile
/// - Adaptive spacing
/// - Adaptive cards
/// - Adaptive assignment controls
/// - Modern loading / empty / error states
///
/// Features:
/// - Current user company loading
/// - Supervisor loading
/// - Supervisor selection
/// - Existing assignment loading
/// - Own Department
/// - All Departments
/// - Customized Departments
/// - Assign / Unassign
/// - Assigned Department table
/// - Unassigned Department list
/// - Refresh
/// - Loading / Error handling
///
/// Data / Logic:
/// - Existing Supervisor Provider / Notifier
/// - Existing SupervisorState
/// - Existing SupervisorAssignmentTable
/// - No CRUD logic changed
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';
import '../widgets/supervisor_assignment_table.dart';

class SupervisorDepartmentAssignmentPage
    extends ConsumerStatefulWidget {
  const SupervisorDepartmentAssignmentPage({
    super.key,
  });

  @override
  ConsumerState<SupervisorDepartmentAssignmentPage> createState() =>
      _SupervisorDepartmentAssignmentPageState();
}

class _SupervisorDepartmentAssignmentPageState
    extends ConsumerState<SupervisorDepartmentAssignmentPage> {
  // =============================================================
  // THEME
  // =============================================================

  static const Color _primaryColor = Color(0xFF2563EB);
  static const Color _primaryDarkColor = Color(0xFF1D4ED8);
  static const Color _backgroundColor = Color(0xFFF6F8FC);
  static const Color _cardColor = Colors.white;
  static const Color _textColor = Color(0xFF111827);
  static const Color _secondaryTextColor = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE5E7EB);
  static const Color _successColor = Color(0xFF16A34A);
  static const Color _warningColor = Color(0xFFF59E0B);
  static const Color _dangerColor = Color(0xFFDC2626);

  // =============================================================
  // RESPONSIVE BREAKPOINTS
  // =============================================================

  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;
  static const double _desktopMaxWidth = 1180;

  // =============================================================
  // SELECTED COMPANY
  // =============================================================

  String? _selectedCompanyId;

  // =============================================================
  // SELECTED SUPERVISOR
  // =============================================================

  String? _selectedSupervisorId;

  // =============================================================
  // ASSIGNMENT TYPE
  // =============================================================

  String _assignmentType = 'own';

  // =============================================================
  // SELECTED DEPARTMENTS
  // =============================================================

  final Set<String> _selectedDepartmentIds = <String>{};

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  // =============================================================
  // INITIALIZE
  // =============================================================

  Future<void> _initialize() async {
    final user = ref.read(currentUserProvider);

    if (user == null) {
      return;
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedCompanyId = companyId;
    });

    await ref
        .read(supervisorProvider.notifier)
        .selectCompany(companyId);
  }

  // =============================================================
  // COMPANY NAME
  // =============================================================

  String _companyName() {
    final user = ref.read(currentUserProvider);

    if (user == null) {
      return 'Current Company';
    }

    try {
      final dynamic value = user;

      final name = value.companyName;

      if (name != null && name.toString().trim().isNotEmpty) {
        return name.toString().trim();
      }
    } catch (_) {
      // CurrentUser model may not contain companyName.
    }

    return 'Current Company';
  }

  // =============================================================
  // RESET ASSIGNMENT
  // =============================================================

  void _resetAssignment() {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSupervisorId = null;
      _assignmentType = 'own';
      _selectedDepartmentIds.clear();
    });
  }

  // =============================================================
  // SUPERVISOR CHANGED
  // =============================================================

  Future<void> _onSupervisorChanged(
      String? supervisorId,
      SupervisorState state,
      ) async {
    if (supervisorId == null || supervisorId.trim().isEmpty) {
      setState(() {
        _selectedSupervisorId = null;
        _selectedDepartmentIds.clear();
      });

      ref.read(supervisorProvider.notifier).clearAssignments();

      return;
    }

    final supervisor = _findSupervisor(
      state.supervisors,
      supervisorId,
    );

    setState(() {
      _selectedSupervisorId = supervisorId;
      _assignmentType = 'own';
      _selectedDepartmentIds.clear();
    });

    final companyId = _selectedCompanyId;

    if (companyId == null || companyId.trim().isEmpty) {
      return;
    }

    final assignments = await ref
        .read(supervisorProvider.notifier)
        .loadSupervisorDepartmentAssignments(
      companyId: companyId,
      supervisorId: supervisorId,
    );

    if (!mounted) {
      return;
    }

    final existingIds = assignments
        .map(
          (assignment) =>
          assignment['department_id']?.toString(),
    )
        .whereType<String>()
        .where(
          (id) => id.trim().isNotEmpty,
    )
        .toSet();

    setState(() {
      _selectedDepartmentIds
        ..clear()
        ..addAll(existingIds);

      if (existingIds.isEmpty) {
        final ownDepartmentId = _ownDepartmentId(
          supervisor,
        );

        if (ownDepartmentId != null) {
          _selectedDepartmentIds.add(
            ownDepartmentId,
          );
        }
      }
    });
  }

  // =============================================================
  // ASSIGNMENT TYPE CHANGED
  // =============================================================

  void _onAssignmentTypeChanged(
      String type,
      SupervisorState state,
      ) {
    final supervisor = _findSupervisor(
      state.supervisors,
      _selectedSupervisorId,
    );

    setState(() {
      _assignmentType = type;
      _selectedDepartmentIds.clear();

      if (type == 'own') {
        final ownDepartmentId = _ownDepartmentId(
          supervisor,
        );

        if (ownDepartmentId != null) {
          _selectedDepartmentIds.add(
            ownDepartmentId,
          );
        }
      }

      if (type == 'all') {
        for (final department in state.departments) {
          final id = department['id']?.toString();

          if (id != null && id.trim().isNotEmpty) {
            _selectedDepartmentIds.add(id);
          }
        }
      }

      if (type == 'customized') {
        // User manually selects departments.
      }
    });
  }

  // =============================================================
  // TOGGLE DEPARTMENT
  // =============================================================

  void _toggleDepartment(
      String departmentId,
      ) {
    if (_assignmentType == 'own') {
      return;
    }

    setState(() {
      if (_selectedDepartmentIds.contains(departmentId)) {
        _selectedDepartmentIds.remove(departmentId);
      } else {
        _selectedDepartmentIds.add(departmentId);
      }
    });
  }

  // =============================================================
  // FIND SUPERVISOR
  // =============================================================

  Map<String, dynamic>? _findSupervisor(
      List<Map<String, dynamic>> supervisors,
      String? supervisorId,
      ) {
    if (supervisorId == null || supervisorId.trim().isEmpty) {
      return null;
    }

    for (final supervisor in supervisors) {
      if (supervisor['id']?.toString() == supervisorId) {
        return supervisor;
      }
    }

    return null;
  }

  // =============================================================
  // NESTED MAP
  // =============================================================

  Map<String, dynamic>? _nestedMap(
      Map<String, dynamic> data,
      String key,
      ) {
    final value = data[key];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  // =============================================================
  // OWN DEPARTMENT ID
  // =============================================================

  String? _ownDepartmentId(
      Map<String, dynamic>? supervisor,
      ) {
    if (supervisor == null) {
      return null;
    }

    final directId = supervisor['department_id']?.toString();

    if (directId != null && directId.trim().isNotEmpty) {
      return directId;
    }

    final department = _nestedMap(
      supervisor,
      'departments',
    );

    final nestedId = department?['id']?.toString();

    if (nestedId != null && nestedId.trim().isNotEmpty) {
      return nestedId;
    }

    return null;
  }

  // =============================================================
  // OWN DEPARTMENT NAME
  // =============================================================

  String _ownDepartmentName(
      Map<String, dynamic>? supervisor,
      ) {
    if (supervisor == null) {
      return '-';
    }

    final department = _nestedMap(
      supervisor,
      'departments',
    );

    final name = department?['name']?.toString().trim();

    if (name != null && name.isNotEmpty) {
      return name;
    }

    return '-';
  }

  // =============================================================
  // SUPERVISOR NAME
  // =============================================================

  String _supervisorName(
      Map<String, dynamic> supervisor,
      ) {
    final employee = _nestedMap(
      supervisor,
      'employees',
    );

    if (employee == null) {
      return 'Unknown Supervisor';
    }

    final fullName = employee['full_name']?.toString().trim();

    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    final firstName =
        employee['first_name']?.toString().trim() ?? '';

    final lastName =
        employee['last_name']?.toString().trim() ?? '';

    final name = '$firstName $lastName'.trim();

    return name.isEmpty ? 'Unknown Supervisor' : name;
  }

  // =============================================================
  // SAVE DEPARTMENTS
  // =============================================================

  Future<void> _saveDepartments(
      SupervisorState state,
      ) async {
    final companyId = _selectedCompanyId;

    if (companyId == null || companyId.trim().isEmpty) {
      _showMessage(
        'Company information is not available.',
      );

      return;
    }

    final supervisorId = _selectedSupervisorId;

    if (supervisorId == null ||
        supervisorId.trim().isEmpty) {
      _showMessage(
        'Please select a supervisor.',
      );

      return;
    }

    final departmentIds = _selectedDepartmentIds
        .map(
          (id) => id.trim(),
    )
        .where(
          (id) => id.isNotEmpty,
    )
        .toSet()
        .toList();

    if (departmentIds.isEmpty) {
      _showMessage(
        'Please select at least one department.',
      );

      return;
    }

    final success = await ref
        .read(supervisorProvider.notifier)
        .updateSupervisorDepartmentAssignments(
      companyId: companyId,
      supervisorId: supervisorId,
      departmentIds: departmentIds,
    );

    if (!mounted) {
      return;
    }

    final updatedState = ref.read(supervisorProvider);

    if (success) {
      _showMessage(
        updatedState.successMessage ??
            'Supervisor departments updated successfully.',
      );

      final assignments = await ref
          .read(supervisorProvider.notifier)
          .loadSupervisorDepartmentAssignments(
        companyId: companyId,
        supervisorId: supervisorId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedDepartmentIds
          ..clear()
          ..addAll(
            assignments
                .map(
                  (item) =>
                  item['department_id']?.toString(),
            )
                .whereType<String>()
                .where(
                  (id) => id.trim().isNotEmpty,
            ),
          );
      });

      return;
    }

    _showMessage(
      updatedState.errorMessage ??
          'Failed to update departments.',
    );
  }

  // =============================================================
  // UNASSIGN
  // =============================================================

  Future<void> _unassignDepartment(
      Map<String, dynamic> assignment,
      ) async {
    final departmentId =
    assignment['department_id']?.toString();

    if (departmentId == null ||
        departmentId.trim().isEmpty) {
      return;
    }

    setState(() {
      _selectedDepartmentIds.remove(
        departmentId,
      );
    });

    final companyId = _selectedCompanyId;
    final supervisorId = _selectedSupervisorId;

    if (companyId == null || supervisorId == null) {
      return;
    }

    await _saveDepartments(
      ref.read(supervisorProvider),
    );
  }

  // =============================================================
  // ASSIGN SINGLE DEPARTMENT
  // =============================================================

  Future<void> _assignSingleDepartment(
      Map<String, dynamic> department,
      ) async {
    final departmentId = department['id']?.toString();

    if (departmentId == null ||
        departmentId.trim().isEmpty) {
      return;
    }

    setState(() {
      _selectedDepartmentIds.add(
        departmentId,
      );
    });

    await _saveDepartments(
      ref.read(supervisorProvider),
    );
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    final companyId = _selectedCompanyId;

    if (companyId == null ||
        companyId.trim().isEmpty) {
      await _initialize();
      return;
    }

    setState(() {
      _selectedSupervisorId = null;
      _assignmentType = 'own';
      _selectedDepartmentIds.clear();
    });

    await ref
        .read(supervisorProvider.notifier)
        .selectCompany(companyId);
  }

  // =============================================================
  // MESSAGE
  // =============================================================

  void _showMessage(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final state = ref.watch(
      supervisorProvider,
    );

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(
        state,
      ),
      body: SafeArea(
        child: _buildBody(
          state,
        ),
      ),
    );
  }

  // =============================================================
  // APP BAR
  // =============================================================

  PreferredSizeWidget _buildAppBar(
      SupervisorState state,
      ) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      foregroundColor: _textColor,

      titleSpacing: 16,

      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Supervisor Departments',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _textColor,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            'Assign departments to supervisors',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: _secondaryTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),

      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: state.isLoading ? null : _refresh,
          icon: const Icon(
            Icons.refresh_rounded,
            size: 22,
          ),
        ),

        const SizedBox(
          width: 4,
        ),
      ],
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody(
      SupervisorState state,
      ) {
    if (state.errorMessage != null &&
        state.departments.isEmpty &&
        state.supervisors.isEmpty) {
      return _buildError(
        state,
      );
    }

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final width = constraints.maxWidth;

        final horizontalPadding = _responsiveHorizontalPadding(
          width,
        );

        final contentWidth = width > _desktopMaxWidth
            ? _desktopMaxWidth
            : width;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: 16,
            bottom: 32,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentWidth,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // PAGE HEADER
                  // =================================================

                  _buildPageHeader(
                    width,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  // =================================================
                  // COMPANY
                  // =================================================

                  _buildCompanyCard(
                    width,
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  // =================================================
                  // LOADING
                  // =================================================

                  if (state.isLoading) ...[
                    _buildLoadingIndicator(),

                    const SizedBox(
                      height: 14,
                    ),
                  ],

                  // =================================================
                  // SUPERVISOR
                  // =================================================

                  _buildSupervisorSection(
                    state,
                    width,
                  ),

                  // =================================================
                  // ASSIGNMENT
                  // =================================================

                  if (_selectedSupervisorId != null) ...[
                    const SizedBox(
                      height: 14,
                    ),

                    _buildAssignmentSection(
                      state,
                      width,
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    _buildAssignmentTable(
                      state,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // RESPONSIVE HORIZONTAL PADDING
  // =============================================================

  double _responsiveHorizontalPadding(
      double width,
      ) {
    if (width < _mobileBreakpoint) {
      return 12;
    }

    if (width < _tabletBreakpoint) {
      return 20;
    }

    return 28;
  }

  // =============================================================
  // PAGE HEADER
  // =============================================================

  Widget _buildPageHeader(
      double width,
      ) {
    final isMobile = width < _mobileBreakpoint;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Supervisor Department Assignment',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w800,
            color: _textColor,
            letterSpacing: -0.4,
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        Text(
          'Manage department access and assignments for supervisors.',
          style: TextStyle(
            fontSize: isMobile ? 11.5 : 12.5,
            color: _secondaryTextColor,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // LOADING INDICATOR
  // =============================================================

  Widget _buildLoadingIndicator() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        20,
      ),
      child: const LinearProgressIndicator(
        minHeight: 3,
      ),
    );
  }

  // =============================================================
  // COMPANY CARD
  // =============================================================

  Widget _buildCompanyCard(
      double width,
      ) {
    final isMobile = width < _mobileBreakpoint;

    return _sectionCard(
      child: Row(
        children: [
          _iconContainer(
            icon: Icons.business_outlined,
            color: _primaryColor,
            size: isMobile ? 42 : 46,
          ),

          SizedBox(
            width: isMobile ? 10 : 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURRENT COMPANY',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: _secondaryTextColor,
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),

                Text(
                  _companyName(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    fontWeight: FontWeight.w800,
                    color: _textColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _successColor.withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: _successColor,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: _successColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SUPERVISOR SECTION
  // =============================================================

  Widget _buildSupervisorSection(
      SupervisorState state,
      double width,
      ) {
    final isMobile = width < _mobileBreakpoint;

    return _sectionCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            icon: Icons.supervisor_account_outlined,
            title: 'Select Supervisor',
            subtitle:
            'Choose a supervisor to manage department access.',
            compact: isMobile,
          ),

          const SizedBox(
            height: 16,
          ),

          DropdownButtonFormField<String>(
            value: _selectedSupervisorId,
            isExpanded: true,

            decoration: _inputDecoration(
              label: 'Supervisor',
              icon: Icons.supervisor_account_outlined,
            ),

            items: state.supervisors.map(
                  (
                  supervisor,
                  ) {
                final id =
                supervisor['id']?.toString();

                if (id == null ||
                    id.trim().isEmpty) {
                  return null;
                }

                final active =
                    supervisor['is_active'] == true;

                return DropdownMenuItem<String>(
                  value: id,

                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _supervisorName(
                            supervisor,
                          ),
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      if (!active) ...[
                        const SizedBox(
                          width: 8,
                        ),
                        _statusBadge(
                          text: 'Inactive',
                          color: _dangerColor,
                        ),
                      ],
                    ],
                  ),
                );
              },
            )
                .whereType<
                DropdownMenuItem<String>>()
                .toList(),

            onChanged: state.isLoading
                ? null
                : (
                value,
                ) {
              _onSupervisorChanged(
                value,
                state,
              );
            },

            hint: const Text(
              'Select supervisor',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),

          if (state.supervisors.isEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: _infoMessage(
                icon: Icons.info_outline_rounded,
                text:
                'No supervisors found for this company.',
                color: _dangerColor,
              ),
            ),
        ],
      ),
    );
  }

  // =============================================================
  // ASSIGNMENT SECTION
  // =============================================================

  Widget _buildAssignmentSection(
      SupervisorState state,
      double width,
      ) {
    final supervisor = _findSupervisor(
      state.supervisors,
      _selectedSupervisorId,
    );

    final isMobile = width < _mobileBreakpoint;

    return _sectionCard(
      padding: EdgeInsets.all(
        isMobile ? 14 : 18,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _buildSupervisorSummary(
            supervisor,
            width,
          ),

          SizedBox(
            height: isMobile ? 16 : 20,
          ),

          _sectionTitle(
            icon: Icons.tune_rounded,
            title: 'Assignment Type',
            subtitle:
            'Choose how departments should be assigned.',
            compact: isMobile,
          ),

          const SizedBox(
            height: 14,
          ),

          _buildAssignmentTypeLayout(
            state,
            width,
          ),

          SizedBox(
            height: isMobile ? 16 : 20,
          ),

          _buildDepartmentList(
            state,
            supervisor,
            width,
          ),

          SizedBox(
            height: isMobile ? 16 : 20,
          ),

          _buildSaveButton(
            state,
            width,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ASSIGNMENT TYPE LAYOUT
  // =============================================================

  Widget _buildAssignmentTypeLayout(
      SupervisorState state,
      double width,
      ) {
    final isMobile = width < _mobileBreakpoint;

    final options = [
      _AssignmentOption(
        value: 'own',
        title: 'Own Department',
        subtitle:
        'Only the supervisor\'s own department.',
        icon: Icons.person_pin_circle_outlined,
      ),
      _AssignmentOption(
        value: 'all',
        title: 'All Departments',
        subtitle:
        'Assign every department in the company.',
        icon: Icons.select_all_rounded,
      ),
      _AssignmentOption(
        value: 'customized',
        title: 'Customized',
        subtitle:
        'Select specific departments manually.',
        icon: Icons.tune_rounded,
      ),
    ];

    if (isMobile) {
      return Column(
        children: options.map(
              (
              option,
              ) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: _buildRadioOption(
                option: option,
                state: state,
              ),
            );
          },
        ).toList(),
      );
    }

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: options.map(
            (
            option,
            ) {
          final isLast =
              option == options.last;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: isLast ? 0 : 10,
              ),
              child: _buildRadioOption(
                option: option,
                state: state,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  // =============================================================
  // SUPERVISOR SUMMARY
  // =============================================================

  Widget _buildSupervisorSummary(
      Map<String, dynamic>? supervisor,
      double width,
      ) {
    if (supervisor == null) {
      return const SizedBox.shrink();
    }

    final name = _supervisorName(
      supervisor,
    );

    final ownDepartment = _ownDepartmentName(
      supervisor,
    );

    final isMobile = width < _mobileBreakpoint;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile ? 12 : 14,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryColor.withValues(
              alpha: 0.07,
            ),
            _primaryColor.withValues(
              alpha: 0.025,
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: _primaryColor.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        children: [
          _iconContainer(
            icon: Icons.supervisor_account_outlined,
            color: _primaryColor,
            size: isMobile ? 42 : 46,
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
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    fontWeight: FontWeight.w800,
                    color: _textColor,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Own Department: $ownDepartment',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _secondaryTextColor,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // RADIO OPTION
  // =============================================================

  Widget _buildRadioOption({
    required _AssignmentOption option,
    required SupervisorState state,
  }) {
    final selected =
        _assignmentType == option.value;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 180,
      ),
      curve: Curves.easeOut,
      width: double.infinity,
      decoration: BoxDecoration(
        color: selected
            ? _primaryColor.withValues(
          alpha: 0.055,
        )
            : Colors.white,
        borderRadius: BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: selected
              ? _primaryColor
              : _borderColor,
          width: selected ? 1.3 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          14,
        ),
        onTap: state.isSaving
            ? null
            : () {
          _onAssignmentTypeChanged(
            option.value,
            state,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          child: Row(
            children: [
              Radio<String>(
                value: option.value,
                groupValue: _assignmentType,
                onChanged: state.isSaving
                    ? null
                    : (
                    newValue,
                    ) {
                  if (newValue == null) {
                    return;
                  }

                  _onAssignmentTypeChanged(
                    newValue,
                    state,
                  );
                },
                activeColor: _primaryColor,
              ),

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: selected
                      ? _primaryColor.withValues(
                    alpha: 0.09,
                  )
                      : const Color(0xFFF3F4F6),
                  borderRadius:
                  BorderRadius.circular(
                    9,
                  ),
                ),
                child: Icon(
                  option.icon,
                  size: 18,
                  color: selected
                      ? _primaryColor
                      : _secondaryTextColor,
                ),
              ),

              const SizedBox(
                width: 9,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                        FontWeight.w700,
                        color: selected
                            ? _primaryDarkColor
                            : _textColor,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      option.subtitle,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.25,
                        color:
                        _secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // DEPARTMENT LIST
  // =============================================================

  Widget _buildDepartmentList(
      SupervisorState state,
      Map<String, dynamic>? supervisor,
      double width,
      ) {
    if (state.departments.isEmpty) {
      return _buildNoDepartmentsState();
    }

    final ownDepartmentId = _ownDepartmentId(
      supervisor,
    );

    final isMobile = width < _mobileBreakpoint;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _sectionTitle(
                icon: Icons.apartment_outlined,
                title: 'Departments',
                subtitle:
                'Select departments for this supervisor.',
                compact: isMobile,
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            _countBadge(
              '${_selectedDepartmentIds.length} selected',
            ),
          ],
        ),

        const SizedBox(
          height: 12,
        ),

        ...state.departments.map(
              (
              department,
              ) {
            final departmentId =
            department['id']?.toString();

            final departmentName =
            department['name']?.toString().trim();

            if (departmentId == null ||
                departmentId.trim().isEmpty) {
              return const SizedBox.shrink();
            }

            final isOwn =
                departmentId == ownDepartmentId;

            final selected =
            _selectedDepartmentIds.contains(
              departmentId,
            );

            final disabled =
                _assignmentType == 'own' &&
                    !isOwn;

            return _buildDepartmentItem(
              departmentId: departmentId,
              departmentName:
              departmentName == null ||
                  departmentName.isEmpty
                  ? 'Unnamed Department'
                  : departmentName,
              isOwn: isOwn,
              selected: selected,
              disabled: disabled,
              state: state,
            );
          },
        ),
      ],
    );
  }

  // =============================================================
  // DEPARTMENT ITEM
  // =============================================================

  Widget _buildDepartmentItem({
    required String departmentId,
    required String departmentName,
    required bool isOwn,
    required bool selected,
    required bool disabled,
    required SupervisorState state,
  }) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 150,
      ),
      margin: const EdgeInsets.only(
        bottom: 7,
      ),
      decoration: BoxDecoration(
        color: selected
            ? _primaryColor.withValues(
          alpha: 0.045,
        )
            : Colors.white,
        borderRadius: BorderRadius.circular(
          12,
        ),
        border: Border.all(
          color: selected
              ? _primaryColor.withValues(
            alpha: 0.45,
          )
              : _borderColor,
        ),
      ),
      child: CheckboxListTile(
        value: selected,
        onChanged: disabled || state.isSaving
            ? null
            : (_) {
          _toggleDepartment(
            departmentId,
          );
        },
        dense: true,
        visualDensity: const VisualDensity(
          horizontal: -2,
          vertical: -2,
        ),
        controlAffinity:
        ListTileControlAffinity.leading,
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        activeColor: _primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                departmentName,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: disabled
                      ? _secondaryTextColor
                      : _textColor,
                ),
              ),
            ),

            if (isOwn)
              _statusBadge(
                text: 'Own',
                color: _warningColor,
              ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // NO DEPARTMENTS
  // =============================================================

  Widget _buildNoDepartmentsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: _borderColor,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.apartment_outlined,
            size: 38,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'No departments found',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'There are no departments available for this company.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: _secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SAVE BUTTON
  // =============================================================

  Widget _buildSaveButton(
      SupervisorState state,
      double width,
      ) {
    final isMobile = width < _mobileBreakpoint;

    return SizedBox(
      width: double.infinity,
      height: isMobile ? 48 : 52,
      child: ElevatedButton.icon(
        onPressed:
        state.isSaving ||
            _selectedDepartmentIds.isEmpty
            ? null
            : () {
          _saveDepartments(
            state,
          );
        },
        icon: state.isSaving
            ? const SizedBox(
          width: 19,
          height: 19,
          child:
          CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Icon(
          Icons.assignment_turned_in_outlined,
          size: 20,
        ),
        label: Text(
          state.isSaving
              ? 'Saving Departments...'
              : 'Save Departments',
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
          const Color(0xFFE5E7EB),
          disabledForegroundColor:
          const Color(0xFF9CA3AF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // ASSIGNMENT TABLE
  // =============================================================

  Widget _buildAssignmentTable(
      SupervisorState state,
      ) {
    final assignments = _buildTableAssignments(
      state,
    );

    final unassigned =
    _buildUnassignedDepartments(
      state,
    );

    return SupervisorAssignmentTable(
      assignments: assignments,
      unassignedDepartments: unassigned,

      onUnassign: _assignmentType == 'own'
          ? null
          : (
          assignment,
          ) {
        _unassignDepartment(
          assignment,
        );
      },

      onAssign: _assignmentType == 'own'
          ? null
          : (
          department,
          ) {
        _assignSingleDepartment(
          department,
        );
      },
    );
  }

  // =============================================================
  // TABLE ASSIGNMENTS
  // =============================================================

  List<Map<String, dynamic>>
  _buildTableAssignments(
      SupervisorState state,
      ) {
    final supervisor = _findSupervisor(
      state.supervisors,
      _selectedSupervisorId,
    );

    final supervisorName = supervisor == null
        ? '-'
        : _supervisorName(
      supervisor,
    );

    return state.assignments.map(
          (
          assignment,
          ) {
        final department = _nestedMap(
          assignment,
          'departments',
        );

        return {
          ...assignment,
          'supervisor_name': supervisorName,
          'department_name':
          department?['name']
              ?.toString()
              .trim() ??
              '-',
        };
      },
    ).toList();
  }

  // =============================================================
  // UNASSIGNED DEPARTMENTS
  // =============================================================

  List<Map<String, dynamic>>
  _buildUnassignedDepartments(
      SupervisorState state,
      ) {
    final assignedIds = state.assignments
        .map(
          (assignment) =>
          assignment['department_id']?.toString(),
    )
        .whereType<String>()
        .toSet();

    return state.departments.where(
          (
          department,
          ) {
        final id = department['id']?.toString();

        if (id == null || id.trim().isEmpty) {
          return false;
        }

        return !assignedIds.contains(
          id,
        );
      },
    ).toList();
  }

  // =============================================================
  // SECTION CARD
  // =============================================================

  Widget _sectionCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ??
          const EdgeInsets.all(
            16,
          ),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: _borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 12,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: child,
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
    bool compact = false,
  }) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Container(
          width: compact ? 34 : 38,
          height: compact ? 34 : 38,
          decoration: BoxDecoration(
            color: _primaryColor.withValues(
              alpha: 0.075,
            ),
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          child: Icon(
            icon,
            size: compact ? 18 : 20,
            color: _primaryColor,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: compact ? 13 : 14,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                ),
              ),

              const SizedBox(
                height: 2,
              ),

              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compact ? 10 : 10.5,
                  color: _secondaryTextColor,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================
  // ICON CONTAINER
  // =============================================================

  Widget _iconContainer({
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.085,
        ),
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      child: Icon(
        icon,
        size: size * 0.48,
        color: color,
      ),
    );
  }

  // =============================================================
  // COUNT BADGE
  // =============================================================

  Widget _countBadge(
      String text,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _primaryColor.withValues(
          alpha: 0.07,
        ),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _primaryDarkColor,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // =============================================================
  // STATUS BADGE
  // =============================================================

  Widget _statusBadge({
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 8.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // =============================================================
  // INFO MESSAGE
  // =============================================================

  Widget _infoMessage({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.06,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: color,
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10.5,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // INPUT DECORATION
  // =============================================================

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        size: 20,
      ),
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFFAFBFD),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 14,
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: _secondaryTextColor,
      ),
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF9CA3AF),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        borderSide: const BorderSide(
          color: _borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        borderSide: const BorderSide(
          color: _borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        borderSide: const BorderSide(
          color: _primaryColor,
          width: 1.4,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        borderSide: const BorderSide(
          color: _borderColor,
        ),
      ),
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  Widget _buildError(
      SupervisorState state,
      ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(
          24,
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 460,
          ),
          padding: const EdgeInsets.all(
            28,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              18,
            ),
            border: Border.all(
              color: _borderColor,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _dangerColor.withValues(
                    alpha: 0.08,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 34,
                  color: _dangerColor,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              const Text(
                'Unable to load data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                state.errorMessage ??
                    'Something went wrong.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: _secondaryTextColor,
                  height: 1.4,
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                  ),
                  label: const Text(
                    'Retry',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _primaryColor,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        11,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// ASSIGNMENT OPTION MODEL
// ===============================================================

class _AssignmentOption {
  final String value;
  final String title;
  final String subtitle;
  final IconData icon;

  const _AssignmentOption({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}