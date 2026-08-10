/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Assignment Management Page
///
/// Version : 2.0.0
///
/// Purpose:
/// - Select company
/// - Select supervisor
/// - Show all departments of selected company
/// - Show currently assigned departments
/// - Add/remove department assignments
/// - Synchronize assignment with database
///
/// Existing supervisor CRUD page is NOT modified.
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';

class SupervisorDepartmentAssignmentManagementPage
    extends ConsumerStatefulWidget {
  const SupervisorDepartmentAssignmentManagementPage({
    super.key,
  });

  @override
  ConsumerState<SupervisorDepartmentAssignmentManagementPage> createState() =>
      _SupervisorDepartmentAssignmentManagementPageState();
}

class _SupervisorDepartmentAssignmentManagementPageState
    extends ConsumerState<SupervisorDepartmentAssignmentManagementPage> {
  // =============================================================
  // SELECTED COMPANY
  // =============================================================

  String? _selectedCompanyId;

  // =============================================================
  // SELECTED SUPERVISOR
  // =============================================================

  String? _selectedSupervisorId;

  // =============================================================
  // SELECTED DEPARTMENTS
  //
  // Current desired assignment state.
  // =============================================================

  final Set<String> _selectedDepartmentIds = <String>{};

  // =============================================================
  // ORIGINAL DEPARTMENTS
  //
  // Database থেকে supervisor-এর original assignments.
  // =============================================================

  final Set<String> _originalDepartmentIds = <String>{};

  // =============================================================
  // ASSIGNMENT LOADING
  // =============================================================

  bool _isLoadingAssignments = false;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (!mounted) {
        return;
      }

      await ref.read(supervisorProvider.notifier).loadCompanies();
    });
  }

  // =============================================================
  // COMPANY CHANGE
  // =============================================================

  Future<void> _onCompanyChanged(
      String? companyId,
      ) async {
    if (companyId == null || companyId.trim().isEmpty) {
      _clearSelection();
      return;
    }

    setState(() {
      _selectedCompanyId = companyId;
      _selectedSupervisorId = null;

      _selectedDepartmentIds.clear();
      _originalDepartmentIds.clear();

      _isLoadingAssignments = false;
    });

    await ref
        .read(supervisorProvider.notifier)
        .selectCompany(companyId);

    if (!mounted) {
      return;
    }
  }

  // =============================================================
  // SUPERVISOR CHANGE
  // =============================================================

  Future<void> _onSupervisorChanged(
      String? supervisorId,
      ) async {
    // -----------------------------------------------------------
    // CLEAR SUPERVISOR
    // -----------------------------------------------------------

    if (supervisorId == null || supervisorId.trim().isEmpty) {
      setState(() {
        _selectedSupervisorId = null;

        _selectedDepartmentIds.clear();
        _originalDepartmentIds.clear();

        _isLoadingAssignments = false;
      });

      return;
    }

    // -----------------------------------------------------------
    // COMPANY VALIDATION
    // -----------------------------------------------------------

    final companyId = _selectedCompanyId;

    if (companyId == null || companyId.trim().isEmpty) {
      _showMessage(
        'Please select a company first.',
      );

      return;
    }

    // -----------------------------------------------------------
    // SAVE REQUESTED SUPERVISOR ID
    //
    // Async request শেষ হওয়ার পরেও যদি একই supervisor selected
    // থাকে তাহলেই result apply করবো.
    // -----------------------------------------------------------

    final requestedSupervisorId = supervisorId;

    // -----------------------------------------------------------
    // UPDATE UI
    // -----------------------------------------------------------

    setState(() {
      _selectedSupervisorId = requestedSupervisorId;

      _selectedDepartmentIds.clear();
      _originalDepartmentIds.clear();

      _isLoadingAssignments = true;
    });

    // -----------------------------------------------------------
    // LOAD EXISTING ASSIGNMENTS
    // -----------------------------------------------------------

    final assignedDepartments = await ref
        .read(supervisorProvider.notifier)
        .loadSupervisorDepartmentAssignments(
      companyId: companyId,
      supervisorId: requestedSupervisorId,
    );

    // -----------------------------------------------------------
    // WIDGET DISPOSED
    // -----------------------------------------------------------

    if (!mounted) {
      return;
    }

    // -----------------------------------------------------------
    // USER ইতিমধ্যে অন্য supervisor select করেছে
    //
    // পুরোনো request-এর result apply করবো না.
    // -----------------------------------------------------------

    if (_selectedSupervisorId != requestedSupervisorId) {
      return;
    }

    // -----------------------------------------------------------
    // EXTRACT DEPARTMENT IDS
    // -----------------------------------------------------------

    final ids = <String>{};

    for (final item in assignedDepartments) {
      final departmentId = item['department_id']?.toString().trim();

      if (departmentId != null && departmentId.isNotEmpty) {
        ids.add(departmentId);
      }
    }

    // -----------------------------------------------------------
    // UPDATE CURRENT + ORIGINAL STATE
    // -----------------------------------------------------------

    setState(() {
      _selectedDepartmentIds
        ..clear()
        ..addAll(ids);

      _originalDepartmentIds
        ..clear()
        ..addAll(ids);

      _isLoadingAssignments = false;
    });
  }

  // =============================================================
  // CLEAR SELECTION
  // =============================================================

  void _clearSelection() {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedCompanyId = null;
      _selectedSupervisorId = null;

      _selectedDepartmentIds.clear();
      _originalDepartmentIds.clear();

      _isLoadingAssignments = false;
    });
  }

  // =============================================================
  // TOGGLE DEPARTMENT
  // =============================================================

  void _toggleDepartment(
      String departmentId,
      ) {
    if (_isLoadingAssignments) {
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
  // SELECT ALL
  // =============================================================

  void _selectAllDepartments(
      SupervisorState state,
      ) {
    if (_isLoadingAssignments) {
      return;
    }

    final Set<String> ids = <String>{};

    for (final department in state.departments) {
      final id = department['id']?.toString().trim();

      if (id != null && id.isNotEmpty) {
        ids.add(id);
      }
    }

    setState(() {
      _selectedDepartmentIds
        ..clear()
        ..addAll(ids);
    });
  }

  // =============================================================
  // CLEAR ALL
  // =============================================================

  void _clearAllDepartments() {
    if (_isLoadingAssignments) {
      return;
    }

    setState(() {
      _selectedDepartmentIds.clear();
    });
  }

  // =============================================================
  // HAS CHANGES
  // =============================================================

  bool _hasChanges() {
    if (_selectedDepartmentIds.length !=
        _originalDepartmentIds.length) {
      return true;
    }

    return !_selectedDepartmentIds.containsAll(
      _originalDepartmentIds,
    );
  }

  // =============================================================
  // SAVE / UPDATE
  // =============================================================

  Future<void> _saveAssignments() async {
    // -----------------------------------------------------------
    // COMPANY VALIDATION
    // -----------------------------------------------------------

    if (_selectedCompanyId == null ||
        _selectedCompanyId!.trim().isEmpty) {
      _showMessage(
        'Please select a company.',
      );

      return;
    }

    // -----------------------------------------------------------
    // SUPERVISOR VALIDATION
    // -----------------------------------------------------------

    if (_selectedSupervisorId == null ||
        _selectedSupervisorId!.trim().isEmpty) {
      _showMessage(
        'Please select a supervisor.',
      );

      return;
    }

    // -----------------------------------------------------------
    // LOADING CHECK
    // -----------------------------------------------------------

    if (_isLoadingAssignments) {
      _showMessage(
        'Please wait while assignments are loading.',
      );

      return;
    }

    // -----------------------------------------------------------
    // CHANGE CHECK
    // -----------------------------------------------------------

    if (!_hasChanges()) {
      _showMessage(
        'No changes found.',
      );

      return;
    }

    // -----------------------------------------------------------
    // SAVE
    //
    // IMPORTANT:
    // Empty list-ও পাঠানো হচ্ছে।
    //
    // এর মাধ্যমে user যদি সব department uncheck করে,
    // তাহলে database থেকেও সব assignment remove হবে।
    // -----------------------------------------------------------

    final success = await ref
        .read(supervisorProvider.notifier)
        .updateSupervisorDepartmentAssignments(
      companyId: _selectedCompanyId!,
      supervisorId: _selectedSupervisorId!,
      departmentIds: _selectedDepartmentIds.toList(),
    );

    // -----------------------------------------------------------
    // MOUNT CHECK
    // -----------------------------------------------------------

    if (!mounted) {
      return;
    }

    // -----------------------------------------------------------
    // FAILED
    // -----------------------------------------------------------

    if (!success) {
      final state = ref.read(supervisorProvider);

      _showMessage(
        state.errorMessage ??
            'Failed to update supervisor departments.',
      );

      return;
    }

    // -----------------------------------------------------------
    // UPDATE ORIGINAL STATE
    // -----------------------------------------------------------

    setState(() {
      _originalDepartmentIds
        ..clear()
        ..addAll(_selectedDepartmentIds);
    });

    // -----------------------------------------------------------
    // SUCCESS MESSAGE
    // -----------------------------------------------------------

    _showMessage(
      'Supervisor department assignments updated successfully.',
    );
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

    // -----------------------------------------------------------
    // FULL NAME
    // -----------------------------------------------------------

    final fullName = employee['full_name']
        ?.toString()
        .trim();

    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    // -----------------------------------------------------------
    // FIRST NAME
    // -----------------------------------------------------------

    final firstName = employee['first_name']
        ?.toString()
        .trim() ??
        '';

    // -----------------------------------------------------------
    // LAST NAME
    // -----------------------------------------------------------

    final lastName = employee['last_name']
        ?.toString()
        .trim() ??
        '';

    // -----------------------------------------------------------
    // COMBINE
    // -----------------------------------------------------------

    final name = '$firstName $lastName'.trim();

    if (name.isEmpty) {
      return 'Unknown Supervisor';
    }

    return name;
  }

  // =============================================================
  // SHOW MESSAGE
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

      _selectedDepartmentIds.clear();
      _originalDepartmentIds.clear();

      _isLoadingAssignments = false;
    });

    await ref
        .read(supervisorProvider.notifier)
        .loadCompanies();

    if (!mounted) {
      return;
    }
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
      backgroundColor: const Color(0xFFF7F8FC),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,

        title: const Text(
          'Supervisor Department Assignment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
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
    // -----------------------------------------------------------
    // INITIAL LOADING
    // -----------------------------------------------------------

    if (state.isLoading &&
        state.companies.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // -----------------------------------------------------------
    // ERROR
    // -----------------------------------------------------------

    if (state.hasError &&
        state.companies.isEmpty) {
      return _buildError(
        state,
      );
    }

    // -----------------------------------------------------------
    // CONTENT
    // -----------------------------------------------------------

    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        16,
      ),

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 900,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              // -------------------------------------------------
              // COMPANY
              // -------------------------------------------------

              _buildCompanySelector(
                state,
              ),

              // -------------------------------------------------
              // SUPERVISOR
              // -------------------------------------------------

              if (_selectedCompanyId != null) ...[
                const SizedBox(
                  height: 14,
                ),

                _buildSupervisorSelector(
                  state,
                ),
              ],

              // -------------------------------------------------
              // ASSIGNMENT
              // -------------------------------------------------

              if (_selectedSupervisorId != null) ...[
                const SizedBox(
                  height: 14,
                ),

                _buildAssignmentPanel(
                  state,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // COMPANY SELECTOR
  // =============================================================

  Widget _buildCompanySelector(
      SupervisorState state,
      ) {
    return _card(
      child: DropdownButtonFormField<String>(
        initialValue: _selectedCompanyId,

        isExpanded: true,

        decoration: _inputDecoration(
          label: 'Company',
          icon: Icons.business_outlined,
        ),

        items: state.companies
            .map<DropdownMenuItem<String>?>(
              (company) {
            final id = company['id']
                ?.toString()
                .trim();

            final name = company['name']
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
  // SUPERVISOR SELECTOR
  // =============================================================

  Widget _buildSupervisorSelector(
      SupervisorState state,
      ) {
    return _card(
      child: DropdownButtonFormField<String>(
        initialValue: _selectedSupervisorId,

        isExpanded: true,

        decoration: _inputDecoration(
          label: 'Supervisor',
          icon: Icons.supervisor_account_outlined,
        ),

        items: state.supervisors
            .map<DropdownMenuItem<String>?>(
              (supervisor) {
            final id = supervisor['id']
                ?.toString()
                .trim();

            if (id == null || id.isEmpty) {
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

        onChanged: state.isLoading
            ? null
            : _onSupervisorChanged,
      ),
    );
  }

  // =============================================================
  // ASSIGNMENT PANEL
  // =============================================================

  Widget _buildAssignmentPanel(
      SupervisorState state,
      ) {
    final supervisor = _findSupervisor(
      state.supervisors,
      _selectedSupervisorId,
    );

    final supervisorName = supervisor == null
        ? 'Unknown Supervisor'
        : _supervisorName(
      supervisor,
    );

    return _card(
      padding: const EdgeInsets.all(
        16,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // -----------------------------------------------------
          // HEADER
          // -----------------------------------------------------

          Row(
            children: [
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

                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      '${_selectedDepartmentIds.length} department(s) selected',

                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // -------------------------------------------------
              // SELECT MENU
              // -------------------------------------------------

              PopupMenuButton<String>(
                enabled:
                !_isLoadingAssignments,

                tooltip:
                'Department selection',

                onSelected: (value) {
                  if (value == 'all') {
                    _selectAllDepartments(
                      state,
                    );
                  }

                  if (value == 'clear') {
                    _clearAllDepartments();
                  }
                },

                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'all',
                    child: Text(
                      'Select All',
                    ),
                  ),

                  PopupMenuItem<String>(
                    value: 'clear',
                    child: Text(
                      'Clear All',
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          // -----------------------------------------------------
          // ASSIGNMENT LOADING
          // -----------------------------------------------------

          if (_isLoadingAssignments)
            Container(
              width: double.infinity,

              margin:
              const EdgeInsets.only(
                bottom: 12,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),

              decoration: BoxDecoration(
                color: const Color(
                  0xFF2196F3,
                ).withValues(
                  alpha: .06,
                ),

                borderRadius:
                BorderRadius.circular(
                  10,
                ),

                border: Border.all(
                  color: const Color(
                    0xFF2196F3,
                  ).withValues(
                    alpha: .15,
                  ),
                ),
              ),

              child: const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: Text(
                      'Loading assigned departments...',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // -----------------------------------------------------
          // CHANGE INDICATOR
          // -----------------------------------------------------

          if (!_isLoadingAssignments &&
              _hasChanges())
            Container(
              width: double.infinity,

              margin:
              const EdgeInsets.only(
                bottom: 12,
              ),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),

              decoration: BoxDecoration(
                color: Colors.orange.withValues(
                  alpha: .08,
                ),

                borderRadius:
                BorderRadius.circular(
                  10,
                ),

                border: Border.all(
                  color: Colors.orange.withValues(
                    alpha: .20,
                  ),
                ),
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Colors.orange,
                  ),

                  SizedBox(
                    width: 8,
                  ),

                  Expanded(
                    child: Text(
                      'You have unsaved changes.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // -----------------------------------------------------
          // DEPARTMENT LIST
          // -----------------------------------------------------

          _buildDepartmentList(
            state,
          ),

          const SizedBox(
            height: 16,
          ),

          // -----------------------------------------------------
          // SAVE BUTTON
          // -----------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 48,

            child: ElevatedButton.icon(
              onPressed:
              state.isSaving ||
                  _isLoadingAssignments ||
                  !_hasChanges()
                  ? null
                  : _saveAssignments,

              icon: state.isSaving
                  ? const SizedBox(
                width: 18,
                height: 18,

                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(
                Icons.save_outlined,
              ),

              label: Text(
                state.isSaving
                    ? 'Saving...'
                    : 'Update Assignment',
              ),

              style:
              ElevatedButton.styleFrom(
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
  // DEPARTMENT LIST
  // =============================================================

  Widget _buildDepartmentList(
      SupervisorState state,
      ) {
    // -----------------------------------------------------------
    // NO DEPARTMENTS
    // -----------------------------------------------------------

    if (state.departments.isEmpty) {
      return Container(
        width: double.infinity,

        padding:
        const EdgeInsets.all(
          24,
        ),

        decoration: BoxDecoration(
          color: Colors.grey.shade50,

          borderRadius:
          BorderRadius.circular(
            12,
          ),

          border: Border.all(
            color: Colors.black12,
          ),
        ),

        child: const Column(
          children: [
            Icon(
              Icons.apartment_outlined,
              size: 36,
              color: Colors.black38,
            ),

            SizedBox(
              height: 8,
            ),

            Text(
              'No departments found.',
              style: TextStyle(
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // -----------------------------------------------------------
    // DEPARTMENT LIST
    // -----------------------------------------------------------

    return Column(
      children: state.departments.map(
            (department) {
          final departmentId = department['id']
              ?.toString()
              .trim();

          final departmentName = department['name']
              ?.toString()
              .trim();

          // -----------------------------------------------------
          // INVALID DEPARTMENT
          // -----------------------------------------------------

          if (departmentId == null ||
              departmentId.isEmpty) {
            return const SizedBox.shrink();
          }

          // -----------------------------------------------------
          // SELECTED
          // -----------------------------------------------------

          final selected =
          _selectedDepartmentIds.contains(
            departmentId,
          );

          // -----------------------------------------------------
          // ORIGINALLY ASSIGNED
          // -----------------------------------------------------

          final originallyAssigned =
          _originalDepartmentIds.contains(
            departmentId,
          );

          // -----------------------------------------------------
          // UI
          // -----------------------------------------------------

          return Container(
            margin:
            const EdgeInsets.only(
              bottom: 8,
            ),

            decoration: BoxDecoration(
              color: selected
                  ? const Color(
                0xFF2196F3,
              ).withValues(
                alpha: .06,
              )
                  : Colors.white,

              borderRadius:
              BorderRadius.circular(
                12,
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

              onChanged:
              _isLoadingAssignments
                  ? null
                  : (_) {
                _toggleDepartment(
                  departmentId,
                );
              },

              controlAffinity:
              ListTileControlAffinity
                  .leading,

              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 10,
              ),

              title: Row(
                children: [
                  // -------------------------------------------------
                  // DEPARTMENT NAME
                  // -------------------------------------------------

                  Expanded(
                    child: Text(
                      departmentName == null ||
                          departmentName.isEmpty
                          ? 'Unnamed Department'
                          : departmentName,

                      style:
                      const TextStyle(
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  // -------------------------------------------------
                  // ASSIGNED BADGE
                  // -------------------------------------------------

                  if (originallyAssigned)
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        Colors.green.withValues(
                          alpha: .10,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: const Text(
                        'Assigned',

                        style:
                        TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  // =============================================================
  // CARD
  // =============================================================

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,

      padding: padding ??
          const EdgeInsets.all(
            14,
          ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          14,
        ),

        border: Border.all(
          color: Colors.black12,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .03,
            ),

            blurRadius: 8,

            offset: const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child: child,
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

      border: OutlineInputBorder(
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
          color: Color(
            0xFF2196F3,
          ),
          width: 1.4,
        ),
      ),

      filled: true,

      fillColor: const Color(
        0xFFFAFBFD,
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
              size: 52,
              color: Colors.red,
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              state.errorMessage ??
                  'Something went wrong.',

              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton.icon(
              onPressed: _refresh,

              icon: const Icon(
                Icons.refresh,
              ),

              label: const Text(
                'Retry',
              ),
            ),
          ],
        ),
      ),
    );
  }
}