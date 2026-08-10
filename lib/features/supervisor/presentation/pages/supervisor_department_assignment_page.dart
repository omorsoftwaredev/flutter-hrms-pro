/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Assignment Page
///
/// Version : 1.1.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';

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

    Future.microtask(() async {
      await ref
          .read(supervisorProvider.notifier)
          .loadCompanies();
    });
  }

  // =============================================================
  // RESET ASSIGNMENT
  // =============================================================

  void _resetAssignment() {
    setState(() {
      _selectedSupervisorId = null;
      _assignmentType = 'own';
      _selectedDepartmentIds.clear();
    });
  }

  // =============================================================
  // COMPANY CHANGED
  // =============================================================

  Future<void> _onCompanyChanged(
      String? companyId,
      ) async {
    if (companyId == null || companyId.trim().isEmpty) {
      setState(() {
        _selectedCompanyId = null;
      });

      _resetAssignment();
      return;
    }

    setState(() {
      _selectedCompanyId = companyId;
      _selectedSupervisorId = null;
      _assignmentType = 'own';
      _selectedDepartmentIds.clear();
    });

    await ref
        .read(supervisorProvider.notifier)
        .selectCompany(companyId);
  }

  // =============================================================
  // SUPERVISOR CHANGED
  // =============================================================

  void _onSupervisorChanged(
      String? supervisorId,
      SupervisorState state,
      ) {
    if (supervisorId == null || supervisorId.trim().isEmpty) {
      setState(() {
        _selectedSupervisorId = null;
        _selectedDepartmentIds.clear();
      });

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

      final ownDepartmentId = _ownDepartmentId(
        supervisor,
      );

      if (ownDepartmentId != null) {
        _selectedDepartmentIds.add(
          ownDepartmentId,
        );
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

      // ---------------------------------------------------------
      // OWN
      // ---------------------------------------------------------

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

      // ---------------------------------------------------------
      // ALL
      // ---------------------------------------------------------

      if (type == 'all') {
        for (final department in state.departments) {
          final id = department['id']?.toString();

          if (id != null && id.isNotEmpty) {
            _selectedDepartmentIds.add(id);
          }
        }
      }

      // ---------------------------------------------------------
      // CUSTOMIZED
      // ---------------------------------------------------------

      if (type == 'customized') {
        // User will select departments manually.
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
    if (supervisorId == null || supervisorId.isEmpty) {
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

    final departmentId =
    supervisor['department_id']?.toString();

    if (departmentId != null && departmentId.isNotEmpty) {
      return departmentId;
    }

    final department = _nestedMap(
      supervisor,
      'departments',
    );

    final nestedId = department?['id']?.toString();

    if (nestedId != null && nestedId.isNotEmpty) {
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

    final fullName =
    employee['full_name']?.toString().trim();

    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    final firstName =
        employee['first_name']?.toString().trim() ?? '';

    final lastName =
        employee['last_name']?.toString().trim() ?? '';

    final name = '$firstName $lastName'.trim();

    return name.isEmpty
        ? 'Unknown Supervisor'
        : name;
  }

  // =============================================================
// ASSIGN DEPARTMENTS
// =============================================================

  Future<void> _assignDepartments(
      SupervisorState state,
      ) async {
    // =============================================================
    // COMPANY VALIDATION
    // =============================================================

    final companyId =
        _selectedCompanyId;

    if (companyId == null ||
        companyId.trim().isEmpty) {
      _showMessage(
        'Please select a company.',
      );

      return;
    }

    // =============================================================
    // SUPERVISOR VALIDATION
    // =============================================================

    final supervisorId =
        _selectedSupervisorId;

    if (supervisorId == null ||
        supervisorId.trim().isEmpty) {
      _showMessage(
        'Please select a supervisor.',
      );

      return;
    }

    // =============================================================
    // DEPARTMENT VALIDATION
    // =============================================================

    final departmentIds =
    _selectedDepartmentIds
        .map(
          (id) => id.toString(),
    )
        .where(
          (id) => id.isNotEmpty,
    )
        .toList();

    if (departmentIds.isEmpty) {
      _showMessage(
        'Please select at least one department.',
      );

      return;
    }

    // =============================================================
    // SAVE
    // =============================================================

    final success =
    await ref
        .read(supervisorProvider.notifier)
        .assignSupervisorDepartments(
      companyId: companyId,
      supervisorId: supervisorId,
      departmentIds: departmentIds,
    );

    // =============================================================
    // RESULT
    // =============================================================

    if (!mounted) {
      return;
    }

    final updatedState =
    ref.read(
      supervisorProvider,
    );

    if (success) {
      _showMessage(
        updatedState.successMessage ??
            'Departments assigned successfully.',
      );

      return;
    }

    _showMessage(
      updatedState.errorMessage ??
          'Failed to assign departments.',
    );
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

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    setState(() {
      _selectedCompanyId = null;
      _selectedSupervisorId = null;
      _assignmentType = 'own';
      _selectedDepartmentIds.clear();
    });

    await ref
        .read(supervisorProvider.notifier)
        .loadCompanies();
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
      backgroundColor: const Color(0xFFF8F9FC),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,

        title: const Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Supervisor Departments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Assign departments to supervisors',
              style: TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.isLoading
                ? null
                : _refresh,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: _buildBody(
          state,
        ),
      ),
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody(
      SupervisorState state,
      ) {
    if (state.isLoading &&
        state.companies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.hasError) {
      return _buildError(
        state,
      );
    }

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 850,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // -------------------------------------------------
                  // COMPANY
                  // -------------------------------------------------

                  _buildCompanySection(
                    state,
                  ),

                  // -------------------------------------------------
                  // SUPERVISOR
                  // -------------------------------------------------

                  if (_selectedCompanyId != null) ...[
                    const SizedBox(
                      height: 10,
                    ),

                    _buildSupervisorSection(
                      state,
                    ),
                  ],

                  // -------------------------------------------------
                  // ASSIGNMENT
                  // -------------------------------------------------

                  if (_selectedSupervisorId != null) ...[
                    const SizedBox(
                      height: 10,
                    ),

                    _buildAssignmentSection(
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
  // COMPANY SECTION
  // =============================================================

  Widget _buildCompanySection(
      SupervisorState state,
      ) {
    return _compactCard(
      child: DropdownButtonFormField<String>(
        value: _selectedCompanyId,
        isExpanded: true,

        decoration: _inputDecoration(
          label: 'Company',
          icon: Icons.business_outlined,
        ),

        items: state.companies
            .map(
              (company) {
            final id =
            company['id']?.toString();

            final name =
            company['name']
                ?.toString()
                .trim();

            if (id == null || id.isEmpty) {
              return null;
            }

            return DropdownMenuItem<String>(
              value: id,

              child: Text(
                name == null || name.isEmpty
                    ? 'Unnamed Company'
                    : name,

                overflow:
                TextOverflow.ellipsis,
              ),
            );
          },
        )
            .whereType<DropdownMenuItem<String>>()
            .toList(),

        onChanged: state.isLoading
            ? null
            : _onCompanyChanged,
      ),
    );
  }

  // =============================================================
  // SUPERVISOR SECTION
  // =============================================================

  Widget _buildSupervisorSection(
      SupervisorState state,
      ) {
    return _compactCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          DropdownButtonFormField<String>(
            value: _selectedSupervisorId,
            isExpanded: true,

            decoration: _inputDecoration(
              label: 'Supervisor',
              icon:
              Icons.supervisor_account_outlined,
            ),

            items: state.supervisors
                .map(
                  (supervisor) {
                final id =
                supervisor['id']?.toString();

                if (id == null ||
                    id.isEmpty) {
                  return null;
                }

                return DropdownMenuItem<String>(
                  value: id,

                  child: Text(
                    _supervisorName(
                      supervisor,
                    ),

                    overflow:
                    TextOverflow.ellipsis,
                  ),
                );
              },
            )
                .whereType<DropdownMenuItem<String>>()
                .toList(),

            onChanged: (value) {
              _onSupervisorChanged(
                value,
                state,
              );
            },
          ),

          if (state.supervisors.isEmpty)
            Padding(
              padding:
              const EdgeInsets.only(
                top: 8,
              ),

              child: Text(
                'No supervisors found for this company.',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 12,
                ),
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
      ) {
    final supervisor = _findSupervisor(
      state.supervisors,
      _selectedSupervisorId,
    );

    return _compactCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // -------------------------------------------------------
          // SUPERVISOR SUMMARY
          // -------------------------------------------------------

          _buildSupervisorSummary(
            supervisor,
          ),

          const SizedBox(
            height: 14,
          ),

          // -------------------------------------------------------
          // ASSIGNMENT TYPE
          // -------------------------------------------------------

          const Text(
            'Assignment Type',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          _buildRadioOption(
            value: 'own',
            title: 'Own Department',
            subtitle:
            'Only the supervisor\'s own department',
            icon:
            Icons.person_pin_circle_outlined,
            state: state,
          ),

          _buildRadioOption(
            value: 'all',
            title: 'All Departments',
            subtitle:
            'Assign all departments in this company',
            icon:
            Icons.select_all_outlined,
            state: state,
          ),

          _buildRadioOption(
            value: 'customized',
            title: 'Customized Departments',
            subtitle:
            'Select specific departments manually',
            icon: Icons.tune_outlined,
            state: state,
          ),

          const SizedBox(
            height: 14,
          ),

          // -------------------------------------------------------
          // DEPARTMENT LIST
          // -------------------------------------------------------

          _buildDepartmentList(
            state,
            supervisor,
          ),

          const SizedBox(
            height: 14,
          ),

          // -------------------------------------------------------
          // ASSIGN BUTTON
          // -------------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed:
              state.isSaving ||
                  _selectedDepartmentIds.isEmpty
                  ? null
                  : () => _assignDepartments(
                state,
              ),
              icon: state.isSaving
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Icon(
                Icons.assignment_turned_in_outlined,
              ),
              label: Text(
                state.isSaving
                    ? 'Assigning...'
                    : 'Assign Departments',
              ),
              style: ElevatedButton.styleFrom(
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SUPERVISOR SUMMARY
  // =============================================================

  Widget _buildSupervisorSummary(
      Map<String, dynamic>? supervisor,
      ) {
    if (supervisor == null) {
      return const SizedBox.shrink();
    }

    final name =
    _supervisorName(
      supervisor,
    );

    final ownDepartment =
    _ownDepartmentName(
      supervisor,
    );

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF2196F3)
            .withValues(
          alpha: .06,
        ),

        borderRadius:
        BorderRadius.circular(
          10,
        ),

        border: Border.all(
          color: const Color(0xFF2196F3)
              .withValues(
            alpha: .12,
          ),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: const Color(0xFF2196F3)
                  .withValues(
                alpha: .10,
              ),

              borderRadius:
              BorderRadius.circular(
                10,
              ),
            ),

            child: const Icon(
              Icons.supervisor_account_outlined,
              color: Color(0xFF1976D2),
              size: 21,
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
                  name,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  'Own Department: $ownDepartment',

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
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
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required SupervisorState state,
  }) {
    final selected =
        _assignmentType == value;

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 6,
      ),

      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF2196F3)
            .withValues(
          alpha: .055,
        )
            : Colors.white,

        borderRadius:
        BorderRadius.circular(
          10,
        ),

        border: Border.all(
          color: selected
              ? const Color(0xFF2196F3)
              : Colors.black12,
        ),
      ),

      child: RadioListTile<String>(
        value: value,

        groupValue:
        _assignmentType,

        onChanged: (newValue) {
          if (newValue == null) {
            return;
          }

          _onAssignmentTypeChanged(
            newValue,
            state,
          );
        },

        secondary: Icon(
          icon,
          size: 21,
          color: selected
              ? const Color(0xFF2196F3)
              : Colors.black54,
        ),

        title: Text(
          title,

          style: const TextStyle(
            fontSize: 14,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        subtitle: Text(
          subtitle,

          style: const TextStyle(
            fontSize: 10.5,
            color: Colors.black54,
          ),
        ),

        dense: true,

        visualDensity:
        const VisualDensity(
          horizontal: -2,
          vertical: -2,
        ),

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 6,
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
      ) {
    if (state.departments.isEmpty) {
      return Container(
        width: double.infinity,

        padding:
        const EdgeInsets.all(
          18,
        ),

        decoration: BoxDecoration(
          color: Colors.grey.shade50,

          borderRadius:
          BorderRadius.circular(
            10,
          ),

          border: Border.all(
            color: Colors.black12,
          ),
        ),

        child: const Column(
          children: [
            Icon(
              Icons.apartment_outlined,
              size: 30,
              color: Colors.black38,
            ),

            SizedBox(
              height: 6,
            ),

            Text(
              'No departments found.',
              style: TextStyle(
                fontWeight:
                FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    final ownDepartmentId =
    _ownDepartmentId(
      supervisor,
    );

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Departments',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),

              decoration: BoxDecoration(
                color: const Color(0xFF2196F3)
                    .withValues(
                  alpha: .07,
                ),

                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),

              child: Text(
                '${_selectedDepartmentIds.length} selected',

                style: const TextStyle(
                  color:
                  Color(0xFF1976D2),
                  fontSize: 10,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 8,
        ),

        ...state.departments.map(
              (department) {
            final departmentId =
            department['id']?.toString();

            final departmentName =
            department['name']
                ?.toString()
                .trim();

            if (departmentId == null ||
                departmentId.isEmpty) {
              return const SizedBox.shrink();
            }

            final isOwn =
                departmentId ==
                    ownDepartmentId;

            final selected =
            _selectedDepartmentIds
                .contains(
              departmentId,
            );

            final disabled =
                _assignmentType == 'own' &&
                    !isOwn;

            return Container(
              margin:
              const EdgeInsets.only(
                bottom: 5,
              ),

              decoration: BoxDecoration(
                color: selected
                    ? const Color(
                  0xFF2196F3,
                ).withValues(
                  alpha: .055,
                )
                    : Colors.white,

                borderRadius:
                BorderRadius.circular(
                  9,
                ),

                border: Border.all(
                  color: selected
                      ? const Color(
                    0xFF2196F3,
                  )
                      : Colors.black12,
                ),
              ),

              child: CheckboxListTile(
                value: selected,

                onChanged: disabled
                    ? null
                    : (_) {
                  _toggleDepartment(
                    departmentId,
                  );
                },

                dense: true,

                visualDensity:
                const VisualDensity(
                  horizontal: -2,
                  vertical: -2,
                ),

                controlAffinity:
                ListTileControlAffinity
                    .leading,

                contentPadding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 7,
                ),

                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        departmentName ==
                            null ||
                            departmentName
                                .isEmpty
                            ? 'Unnamed Department'
                            : departmentName,

                        maxLines: 1,

                        overflow:
                        TextOverflow.ellipsis,

                        style:
                        const TextStyle(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),

                    if (isOwn)
                      Container(
                        padding:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),

                        decoration:
                        BoxDecoration(
                          color: Colors.orange
                              .withValues(
                            alpha: .10,
                          ),

                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                        ),

                        child:
                        const Text(
                          'Own',

                          style:
                          TextStyle(
                            color:
                            Colors.orange,
                            fontSize: 9,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // =============================================================
  // COMPACT CARD
  // =============================================================

  Widget _compactCard({
    required Widget child,
  }) {
    return Card(
      elevation: 0.8,

      margin:
      EdgeInsets.zero,

      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(
          14,
        ),
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(
          12,
        ),

        child: child,
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
        size: 21,
      ),

      isDense: true,

      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),

      border:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          11,
        ),
      ),

      enabledBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          11,
        ),

        borderSide:
        const BorderSide(
          color: Colors.black12,
        ),
      ),

      focusedBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(
          11,
        ),

        borderSide:
        const BorderSide(
          color: Color(0xFF2196F3),
          width: 1.4,
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
      child: Padding(
        padding:
        const EdgeInsets.all(
          24,
        ),

        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              state.errorMessage ??
                  'Something went wrong.',

              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
              height: 14,
            ),

            ElevatedButton.icon(
              onPressed:
              _refresh,

              icon: const Icon(
                Icons.refresh,
              ),

              label:
              const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}