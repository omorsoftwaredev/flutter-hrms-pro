/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Assignment Management Page
///
/// Version : 3.1.0
///
/// Purpose:
/// - Company ID comes automatically from logged-in CurrentUser
/// - Company dropdown is NOT used
/// - Load departments for logged-in user's company
/// - Load supervisors for logged-in user's company
/// - Select supervisor
/// - Load existing supervisor department assignments
/// - Show all company departments
/// - Select / unselect departments
/// - Select all / clear all
/// - Detect unsaved changes
/// - Save final department assignments
/// - Synchronize assignment with database
///
/// IMPORTANT:
/// Company is NOT selected manually on this page.
///
/// Company ID comes from:
///
/// currentUserProvider
///       ↓
/// CurrentUser.companyId
///       ↓
/// SupervisorNotifier.selectCompany(companyId)
///
/// Existing Supervisor CRUD page is NOT modified.
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';

class SupervisorDepartmentAssignmentManagementPage
    extends ConsumerStatefulWidget {
  const SupervisorDepartmentAssignmentManagementPage({super.key});

  @override
  ConsumerState<SupervisorDepartmentAssignmentManagementPage> createState() =>
      _SupervisorDepartmentAssignmentManagementPageState();
}

class _SupervisorDepartmentAssignmentManagementPageState
    extends ConsumerState<SupervisorDepartmentAssignmentManagementPage> {
  // =============================================================
  // LOGIN USER COMPANY ID
  //
  // This is NOT selected from UI.
  //
  // It comes from:
  // currentUserProvider -> CurrentUser.companyId
  // =============================================================

  String? _companyId;

  // =============================================================
  // LOGIN USER COMPANY NAME
  //
  // Information only.
  // No company dropdown is used.
  // =============================================================

  String? _companyName;

  // =============================================================
  // SELECTED SUPERVISOR
  // =============================================================

  String? _selectedSupervisorId;

  // =============================================================
  // CURRENT SELECTED DEPARTMENTS
  //
  // Represents the desired final state.
  // =============================================================

  final Set<String> _selectedDepartmentIds = <String>{};

  // =============================================================
  // ORIGINAL DATABASE ASSIGNMENTS
  //
  // Used for change detection.
  // =============================================================

  final Set<String> _originalDepartmentIds = <String>{};

  // =============================================================
  // INITIAL PAGE LOADING
  // =============================================================

  bool _isInitializing = true;

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

    Future.microtask(_initializePage);
  }

  // =============================================================
  // INITIALIZE PAGE
  //
  // Company ID comes from logged-in user.
  // =============================================================

  Future<void> _initializePage() async {
    if (!mounted) {
      return;
    }

    if (_isInitializing == false) {
      setState(() {
        _isInitializing = true;
      });
    }

    try {
      // ---------------------------------------------------------
      // GET CURRENT LOGGED-IN USER
      // ---------------------------------------------------------

      final currentUser = ref.read(currentUserProvider);

      // ---------------------------------------------------------
      // USER VALIDATION
      // ---------------------------------------------------------

      if (currentUser == null) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isInitializing = false;
        });

        _showMessage('Current user information is not available.');

        return;
      }

      // ---------------------------------------------------------
      // COMPANY ID
      //
      // No company dropdown.
      // No manual company selection.
      // ---------------------------------------------------------

      final companyId = currentUser.companyId.trim();

      if (companyId.isEmpty) {
        if (!mounted) {
          return;
        }

        setState(() {
          _isInitializing = false;
        });

        _showMessage('Company information is not available for this account.');

        return;
      }

      // ---------------------------------------------------------
      // COMPANY NAME
      // ---------------------------------------------------------

      final companyName = currentUser.companyName?.trim();

      // ---------------------------------------------------------
      // STORE COMPANY CONTEXT
      // ---------------------------------------------------------

      if (!mounted) {
        return;
      }

      setState(() {
        _companyId = companyId;

        _companyName = companyName == null || companyName.isEmpty
            ? null
            : companyName;

        _selectedSupervisorId = null;

        _selectedDepartmentIds.clear();
        _originalDepartmentIds.clear();

        _isLoadingAssignments = false;
      });

      // ---------------------------------------------------------
      // LOAD COMPANY DATA
      //
      // Existing SupervisorNotifier method:
      //
      // selectCompany(companyId)
      //
      // This loads:
      // - departments
      // - supervisors
      // ---------------------------------------------------------

      await ref.read(supervisorProvider.notifier).selectCompany(companyId);

      // ---------------------------------------------------------
      // MOUNT CHECK
      // ---------------------------------------------------------

      if (!mounted) {
        return;
      }

      // ---------------------------------------------------------
      // FINISHED
      // ---------------------------------------------------------

      setState(() {
        _isInitializing = false;
      });

      // ---------------------------------------------------------
      // SHOW PROVIDER ERROR IF AVAILABLE
      // ---------------------------------------------------------

      final state = ref.read(supervisorProvider);

      if (state.errorMessage != null && state.errorMessage!.trim().isNotEmpty) {
        _showMessage(state.errorMessage!);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitializing = false;
      });

      _showMessage('Failed to load company information.');
    }
  }

  // =============================================================
  // SUPERVISOR CHANGE
  // =============================================================

  Future<void> _onSupervisorChanged(String? supervisorId) async {
    // -----------------------------------------------------------
    // CLEAR SUPERVISOR
    // -----------------------------------------------------------

    if (supervisorId == null || supervisorId.trim().isEmpty) {
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedSupervisorId = null;

        _selectedDepartmentIds.clear();
        _originalDepartmentIds.clear();

        _isLoadingAssignments = false;
      });

      return;
    }

    // -----------------------------------------------------------
    // COMPANY ID
    // -----------------------------------------------------------

    final companyId = _companyId;

    if (companyId == null || companyId.trim().isEmpty) {
      _showMessage('Company information is not available.');

      return;
    }

    // -----------------------------------------------------------
    // REQUESTED SUPERVISOR
    // -----------------------------------------------------------

    final requestedSupervisorId = supervisorId.trim();

    // -----------------------------------------------------------
    // UPDATE UI
    // -----------------------------------------------------------

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSupervisorId = requestedSupervisorId;

      _selectedDepartmentIds.clear();
      _originalDepartmentIds.clear();

      _isLoadingAssignments = true;
    });

    try {
      // ---------------------------------------------------------
      // LOAD EXISTING ASSIGNMENTS
      // ---------------------------------------------------------

      final assignedDepartments = await ref
          .read(supervisorProvider.notifier)
          .loadSupervisorDepartmentAssignments(
            companyId: companyId,
            supervisorId: requestedSupervisorId,
          );

      // ---------------------------------------------------------
      // MOUNT CHECK
      // ---------------------------------------------------------

      if (!mounted) {
        return;
      }

      // ---------------------------------------------------------
      // IMPORTANT:
      //
      // Prevent an old async request from updating the current
      // supervisor.
      // ---------------------------------------------------------

      if (_selectedSupervisorId != requestedSupervisorId) {
        return;
      }

      // ---------------------------------------------------------
      // EXTRACT DEPARTMENT IDS
      // ---------------------------------------------------------

      final ids = <String>{};

      for (final item in assignedDepartments) {
        final departmentId = item['department_id']?.toString().trim();

        if (departmentId != null && departmentId.isNotEmpty) {
          ids.add(departmentId);
        }
      }

      // ---------------------------------------------------------
      // APPLY DATABASE ASSIGNMENTS
      // ---------------------------------------------------------

      setState(() {
        _selectedDepartmentIds
          ..clear()
          ..addAll(ids);

        _originalDepartmentIds
          ..clear()
          ..addAll(ids);

        _isLoadingAssignments = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      // ---------------------------------------------------------
      // IMPORTANT:
      //
      // Do NOT allow an old request's error to modify the current
      // supervisor's state.
      // ---------------------------------------------------------

      if (_selectedSupervisorId != requestedSupervisorId) {
        return;
      }

      setState(() {
        _isLoadingAssignments = false;
      });

      _showMessage('Failed to load department assignments.');
    }
  }

  // =============================================================
  // TOGGLE DEPARTMENT
  // =============================================================

  void _toggleDepartment(String departmentId) {
    final id = departmentId.trim();

    if (id.isEmpty || _isLoadingAssignments) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      if (_selectedDepartmentIds.contains(id)) {
        _selectedDepartmentIds.remove(id);
      } else {
        _selectedDepartmentIds.add(id);
      }
    });
  }

  // =============================================================
  // SELECT ALL
  // =============================================================

  void _selectAllDepartments(SupervisorState state) {
    if (_isLoadingAssignments) {
      return;
    }

    final ids = <String>{};

    for (final department in state.departments) {
      final id = department['id']?.toString().trim();

      if (id != null && id.isNotEmpty) {
        ids.add(id);
      }
    }

    if (!mounted) {
      return;
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

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedDepartmentIds.clear();
    });
  }

  // =============================================================
  // HAS CHANGES
  //
  // Compares selected state with original database state.
  // =============================================================

  bool _hasChanges() {
    if (_selectedDepartmentIds.length != _originalDepartmentIds.length) {
      return true;
    }

    return !_selectedDepartmentIds.containsAll(_originalDepartmentIds);
  }

  // =============================================================
  // SAVE ASSIGNMENTS
  // =============================================================

  Future<void> _saveAssignments() async {
    // -----------------------------------------------------------
    // COMPANY VALIDATION
    // -----------------------------------------------------------

    final companyId = _companyId;

    if (companyId == null || companyId.trim().isEmpty) {
      _showMessage('Company information is not available.');

      return;
    }

    // -----------------------------------------------------------
    // SUPERVISOR VALIDATION
    // -----------------------------------------------------------

    final supervisorId = _selectedSupervisorId;

    if (supervisorId == null || supervisorId.trim().isEmpty) {
      _showMessage('Please select a supervisor.');

      return;
    }

    // -----------------------------------------------------------
    // ASSIGNMENT LOADING VALIDATION
    // -----------------------------------------------------------

    if (_isLoadingAssignments) {
      _showMessage('Please wait while assignments are loading.');

      return;
    }

    // -----------------------------------------------------------
    // PREVENT DUPLICATE SAVE
    // -----------------------------------------------------------

    final currentState = ref.read(supervisorProvider);

    if (currentState.isSaving) {
      return;
    }

    // -----------------------------------------------------------
    // CHANGE VALIDATION
    // -----------------------------------------------------------

    if (!_hasChanges()) {
      _showMessage('No changes found.');

      return;
    }

    // -----------------------------------------------------------
    // CREATE FINAL LIST
    //
    // Empty list is intentionally allowed.
    //
    // If user removes every department,
    // database should remove all assignments.
    // -----------------------------------------------------------

    final departmentIds = _selectedDepartmentIds.toList();

    // -----------------------------------------------------------
    // SAVE
    // -----------------------------------------------------------

    final success = await ref
        .read(supervisorProvider.notifier)
        .updateSupervisorDepartmentAssignments(
          companyId: companyId,
          supervisorId: supervisorId,
          departmentIds: departmentIds,
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

      final errorMessage = state.errorMessage;

      _showMessage(
        errorMessage == null || errorMessage.trim().isEmpty
            ? 'Failed to update supervisor departments.'
            : errorMessage,
      );

      return;
    }

    // -----------------------------------------------------------
    // IMPORTANT:
    //
    // Only update original state AFTER database save succeeds.
    // -----------------------------------------------------------

    setState(() {
      _originalDepartmentIds
        ..clear()
        ..addAll(_selectedDepartmentIds);
    });

    // -----------------------------------------------------------
    // SUCCESS
    // -----------------------------------------------------------

    _showMessage('Supervisor department assignments updated successfully.');
  }

  // =============================================================
  // FIND SUPERVISOR
  // =============================================================

  Map<String, dynamic>? _findSupervisor(
    List<Map<String, dynamic>> supervisors,
    String? supervisorId,
  ) {
    final id = supervisorId?.trim();

    if (id == null || id.isEmpty) {
      return null;
    }

    for (final supervisor in supervisors) {
      final supervisorMapId = supervisor['id']?.toString().trim();

      if (supervisorMapId == id) {
        return supervisor;
      }
    }

    return null;
  }

  // =============================================================
  // NESTED MAP
  // =============================================================

  Map<String, dynamic>? _nestedMap(Map<String, dynamic> data, String key) {
    final value = data[key];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  // =============================================================
  // SUPERVISOR NAME
  // =============================================================

  String _supervisorName(Map<String, dynamic> supervisor) {
    final employee = _nestedMap(supervisor, 'employees');

    if (employee == null) {
      return 'Unknown Supervisor';
    }

    // -----------------------------------------------------------
    // FULL NAME
    // -----------------------------------------------------------

    final fullName = employee['full_name']?.toString().trim();

    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    // -----------------------------------------------------------
    // FIRST NAME
    // -----------------------------------------------------------

    final firstName = employee['first_name']?.toString().trim() ?? '';

    // -----------------------------------------------------------
    // LAST NAME
    // -----------------------------------------------------------

    final lastName = employee['last_name']?.toString().trim() ?? '';

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

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // =============================================================
  // REFRESH
  //
  // IMPORTANT:
  // Refresh DOES NOT ask for company.
  //
  // It uses the same logged-in user's company.
  // =============================================================

  Future<void> _refresh() async {
    final companyId = _companyId;

    if (companyId == null || companyId.trim().isEmpty) {
      await _initializePage();
      return;
    }

    if (!mounted) {
      return;
    }

    // -----------------------------------------------------------
    // RESET CURRENT SELECTION
    // -----------------------------------------------------------

    setState(() {
      _selectedSupervisorId = null;

      _selectedDepartmentIds.clear();
      _originalDepartmentIds.clear();

      _isLoadingAssignments = false;
    });

    try {
      // ---------------------------------------------------------
      // RELOAD COMPANY DATA
      // ---------------------------------------------------------

      await ref.read(supervisorProvider.notifier).selectCompany(companyId);

      // ---------------------------------------------------------
      // MOUNT CHECK
      // ---------------------------------------------------------

      if (!mounted) {
        return;
      }

      // ---------------------------------------------------------
      // SHOW PROVIDER ERROR IF AVAILABLE
      // ---------------------------------------------------------

      final state = ref.read(supervisorProvider);

      if (state.errorMessage != null && state.errorMessage!.trim().isNotEmpty) {
        _showMessage(state.errorMessage!);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage('Failed to refresh company data.');
    }
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supervisorProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supervisor Department Assignment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              'Manage department assignments',
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
            onPressed: state.isLoading || state.isSaving || _isInitializing
                ? null
                : _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: SafeArea(child: _buildBody(state)),
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody(SupervisorState state) {
    // -----------------------------------------------------------
    // INITIAL PAGE LOADING
    // -----------------------------------------------------------

    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    // -----------------------------------------------------------
    // COMPANY NOT AVAILABLE
    // -----------------------------------------------------------

    if (_companyId == null || _companyId!.trim().isEmpty) {
      return _buildCompanyError();
    }

    // -----------------------------------------------------------
    // CONTENT
    // -----------------------------------------------------------

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =================================================
              // PAGE HEADER
              // =================================================
              const Text(
                'Department Assignment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 5),

              const Text(
                'Select a supervisor and manage department assignments.',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),

              const SizedBox(height: 18),

              // =================================================
              // COMPANY CONTEXT
              //
              // INFORMATION ONLY
              // NO DROPDOWN
              // =================================================
              _buildCompanyContext(),

              const SizedBox(height: 14),

              // =================================================
              // SUPERVISOR SELECTOR
              // =================================================
              _buildSupervisorSelector(state),

              // =================================================
              // ASSIGNMENT PANEL
              // =================================================
              if (_selectedSupervisorId != null) ...[
                const SizedBox(height: 14),

                _buildAssignmentPanel(state),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // COMPANY CONTEXT
  //
  // This replaces the old company dropdown.
  // =============================================================

  Widget _buildCompanyContext() {
    return _card(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withValues(alpha: .08),
              borderRadius: BorderRadius.circular(11),
            ),

            child: const Icon(
              Icons.business_outlined,
              color: Color(0xFF1976D2),
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Company',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _companyName == null || _companyName!.isEmpty
                      ? 'Current Login Company'
                      : _companyName!,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // -----------------------------------------------------
          // LOCK / AUTO BADGE
          // -----------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Row(
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(Icons.lock_outline, size: 13, color: Colors.green),

                SizedBox(width: 4),

                Text(
                  'Auto',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
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
  // COMPANY ERROR
  // =============================================================

  Widget _buildCompanyError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(Icons.business_outlined, size: 52, color: Colors.red),

            const SizedBox(height: 12),

            const Text(
              'Company information is not available for the logged-in user.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _initializePage,

              icon: const Icon(Icons.refresh),

              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // SUPERVISOR SELECTOR
  // =============================================================

  Widget _buildSupervisorSelector(SupervisorState state) {
    final items = state.supervisors
        .map<DropdownMenuItem<String>?>((supervisor) {
          final id = supervisor['id']?.toString().trim();

          if (id == null || id.isEmpty) {
            return null;
          }

          return DropdownMenuItem<String>(
            value: id,

            child: Text(
              _supervisorName(supervisor),
              overflow: TextOverflow.ellipsis,
            ),
          );
        })
        .whereType<DropdownMenuItem<String>>()
        .toList();

    // -----------------------------------------------------------
    // SAFETY:
    //
    // If selected supervisor no longer exists in the loaded list,
    // do not pass an invalid value to DropdownButtonFormField.
    // -----------------------------------------------------------

    final validSelectedSupervisorId =
        items.any((item) => item.value == _selectedSupervisorId)
        ? _selectedSupervisorId
        : null;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          DropdownButtonFormField<String>(
            initialValue: validSelectedSupervisorId,

            isExpanded: true,

            decoration: _inputDecoration(
              label: 'Supervisor',
              icon: Icons.supervisor_account_outlined,
            ),

            items: items,

            onChanged: state.isLoading || state.isSaving || _isInitializing
                ? null
                : _onSupervisorChanged,
          ),

          // -----------------------------------------------------
          // NO SUPERVISORS
          // -----------------------------------------------------
          if (state.supervisors.isEmpty && !state.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 8),

              child: Text(
                'No supervisors found for this company.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),

          // -----------------------------------------------------
          // LOADING SUPERVISORS
          // -----------------------------------------------------
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 10),

              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,

                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),

                  SizedBox(width: 8),

                  Text(
                    'Loading supervisors...',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // =============================================================
  // ASSIGNMENT PANEL
  // =============================================================

  Widget _buildAssignmentPanel(SupervisorState state) {
    final supervisor = _findSupervisor(
      state.supervisors,
      _selectedSupervisorId,
    );

    final supervisorName = supervisor == null
        ? 'Unknown Supervisor'
        : _supervisorName(supervisor);

    return _card(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // =====================================================
          // HEADER
          // =====================================================
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      supervisorName,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

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

              // =================================================
              // SELECT MENU
              // =================================================
              PopupMenuButton<String>(
                enabled: !_isLoadingAssignments && !state.isSaving,

                tooltip: 'Department selection',

                onSelected: (value) {
                  if (value == 'all') {
                    _selectAllDepartments(state);
                  } else if (value == 'clear') {
                    _clearAllDepartments();
                  }
                },

                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'all',
                    child: Text('Select All'),
                  ),

                  PopupMenuItem<String>(
                    value: 'clear',
                    child: Text('Clear All'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // =====================================================
          // ASSIGNMENT LOADING
          // =====================================================
          if (_isLoadingAssignments)
            Container(
              width: double.infinity,

              margin: const EdgeInsets.only(bottom: 12),

              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),

              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withValues(alpha: .06),

                borderRadius: BorderRadius.circular(10),

                border: Border.all(
                  color: const Color(0xFF2196F3).withValues(alpha: .15),
                ),
              ),

              child: const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,

                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Loading assigned departments...',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // =====================================================
          // UNSAVED CHANGES
          // =====================================================
          if (!_isLoadingAssignments && !state.isSaving && _hasChanges())
            Container(
              width: double.infinity,

              margin: const EdgeInsets.only(bottom: 12),

              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: .08),

                borderRadius: BorderRadius.circular(10),

                border: Border.all(color: Colors.orange.withValues(alpha: .20)),
              ),

              child: const Row(
                children: [
                  Icon(Icons.edit_outlined, size: 18, color: Colors.orange),

                  SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'You have unsaved changes.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // =====================================================
          // DEPARTMENT LIST
          // =====================================================
          _buildDepartmentList(state),

          const SizedBox(height: 16),

          // =====================================================
          // SAVE BUTTON
          // =====================================================
          SizedBox(
            width: double.infinity,

            height: 48,

            child: ElevatedButton.icon(
              onPressed:
                  state.isSaving || _isLoadingAssignments || !_hasChanges()
                  ? null
                  : _saveAssignments,

              icon: state.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,

                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),

              label: Text(state.isSaving ? 'Saving...' : 'Update Assignment'),

              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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

  Widget _buildDepartmentList(SupervisorState state) {
    // -----------------------------------------------------------
    // NO DEPARTMENTS
    // -----------------------------------------------------------

    if (state.departments.isEmpty) {
      return Container(
        width: double.infinity,

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.grey.shade50,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: Colors.black12),
        ),

        child: const Column(
          children: [
            Icon(Icons.apartment_outlined, size: 36, color: Colors.black38),

            SizedBox(height: 8),

            Text(
              'No departments found.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    // -----------------------------------------------------------
    // DEPARTMENT LIST
    // -----------------------------------------------------------

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // -------------------------------------------------------
        // HEADER
        // -------------------------------------------------------
        Row(
          children: [
            const Expanded(
              child: Text(
                'Departments',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),

              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withValues(alpha: .08),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                '${_selectedDepartmentIds.length} selected',

                style: const TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // -------------------------------------------------------
        // DEPARTMENTS
        // -------------------------------------------------------
        ...state.departments.map((department) {
          final departmentId = department['id']?.toString().trim();

          final departmentName = department['name']?.toString().trim();

          // ---------------------------------------------------
          // INVALID DEPARTMENT
          // ---------------------------------------------------

          if (departmentId == null || departmentId.isEmpty) {
            return const SizedBox.shrink();
          }

          // ---------------------------------------------------
          // SELECTED
          // ---------------------------------------------------

          final selected = _selectedDepartmentIds.contains(departmentId);

          // ---------------------------------------------------
          // ORIGINAL ASSIGNMENT
          // ---------------------------------------------------

          final originallyAssigned = _originalDepartmentIds.contains(
            departmentId,
          );

          // ---------------------------------------------------
          // DEPARTMENT ITEM
          // ---------------------------------------------------

          return Container(
            margin: const EdgeInsets.only(bottom: 8),

            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF2196F3).withValues(alpha: .06)
                  : Colors.white,

              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: selected ? const Color(0xFF2196F3) : Colors.black12,
              ),
            ),

            child: CheckboxListTile(
              value: selected,

              onChanged: _isLoadingAssignments || state.isSaving
                  ? null
                  : (_) {
                      _toggleDepartment(departmentId);
                    },

              controlAffinity: ListTileControlAffinity.leading,

              contentPadding: const EdgeInsets.symmetric(horizontal: 10),

              title: Row(
                children: [
                  // -------------------------------------------
                  // NAME
                  // -------------------------------------------
                  Expanded(
                    child: Text(
                      departmentName == null || departmentName.isEmpty
                          ? 'Unnamed Department'
                          : departmentName,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // -------------------------------------------
                  // ASSIGNED BADGE
                  // -------------------------------------------
                  if (originallyAssigned)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: .10),

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Text(
                        'Assigned',

                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // =============================================================
  // CARD
  // =============================================================

  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,

      padding: padding ?? const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: Colors.black12),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),

            blurRadius: 8,

            offset: const Offset(0, 3),
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

      prefixIcon: Icon(icon, size: 20),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),

        borderSide: const BorderSide(color: Colors.black12),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),

        borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.4),
      ),

      filled: true,

      fillColor: const Color(0xFFFAFBFD),
    );
  }
}
