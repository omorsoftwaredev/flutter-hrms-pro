/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Management Page
///
/// Responsibilities:
/// - Use current logged-in user's company
/// - Load departments
/// - Load supervisors
/// - Open supervisor create form
/// - Load employees by department
/// - Create supervisor
/// - Refresh supervisor list
/// - Toggle supervisor status
/// - Delete supervisor
///
/// Design:
/// - Similar to DesignationListPage
/// - No company dropdown
/// - No success/error alert dialog
/// - Uses SnackBar for feedback
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';

import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';

import '../widgets/supervisor_form.dart';
import '../widgets/supervisor_table.dart';

class SupervisorPage extends ConsumerStatefulWidget {
  const SupervisorPage({super.key});

  @override
  ConsumerState<SupervisorPage> createState() => _SupervisorPageState();
}

// =================================================================
// STATE
// =================================================================

class _SupervisorPageState extends ConsumerState<SupervisorPage> {
  // ===============================================================
  // INIT
  // ===============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await _initialize();
    });
  }

  // ===============================================================
  // INITIALIZE
  // ===============================================================

  Future<void> _initialize() async {
    final notifier = ref.read(supervisorProvider.notifier);

    final user = ref.read(currentUserProvider);

    debugPrint('========================================');
    debugPrint('SUPERVISOR PAGE INITIALIZE');
    debugPrint('CURRENT USER = $user');
    debugPrint('========================================');

    final companyId = _getCompanyIdFromUser(user);

    debugPrint('CURRENT COMPANY ID = $companyId');

    if (companyId == null || companyId.isEmpty) {
      notifier.setError('Current user company is not available.');

      return;
    }

    try {
      // -----------------------------------------------------------
      // SELECT CURRENT COMPANY
      //
      // Provider-এর ভিতর থেকে:
      // - departments load
      // - supervisors load
      // করবে।
      // -----------------------------------------------------------

      await notifier.selectCompany(companyId);

      if (!mounted) {
        return;
      }

      final state = ref.read(supervisorProvider);

      debugPrint(
        'DEPARTMENTS LOADED = '
        '${state.departments.length}',
      );

      debugPrint(
        'SUPERVISORS LOADED = '
        '${state.supervisors.length}',
      );

      debugPrint('SUPERVISOR PAGE INITIALIZE COMPLETE');

      debugPrint('========================================');
    } catch (e) {
      debugPrint('SUPERVISOR INITIALIZE ERROR = $e');
    }
  }

  // ===============================================================
  // GET COMPANY ID
  // ===============================================================

  String? _getCompanyIdFromUser(dynamic user) {
    if (user == null) {
      return null;
    }

    // -------------------------------------------------------------
    // companyId
    // -------------------------------------------------------------

    try {
      final value = user.companyId;

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    } catch (_) {}

    // -------------------------------------------------------------
    // company_id
    // -------------------------------------------------------------

    try {
      final value = user.company_id;

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    } catch (_) {}

    // -------------------------------------------------------------
    // Map
    // -------------------------------------------------------------

    if (user is Map) {
      final value = user['company_id'] ?? user['companyId'];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return null;
  }

  // ===============================================================
  // CURRENT COMPANY ID
  // ===============================================================

  String? _currentCompanyId() {
    final state = ref.read(supervisorProvider);

    final stateCompany = state.selectedCompanyId;

    if (stateCompany != null && stateCompany.trim().isNotEmpty) {
      return stateCompany.trim();
    }

    final user = ref.read(currentUserProvider);

    return _getCompanyIdFromUser(user);
  }

  // ===============================================================
  // DEPARTMENT CHANGED
  // ===============================================================

  Future<void> _onDepartmentChanged(String? departmentId) async {
    if (departmentId == null || departmentId.trim().isEmpty) {
      return;
    }

    final companyId = _currentCompanyId();

    if (companyId == null || companyId.isEmpty) {
      _showSnackBar('Current user company is not available.', isError: true);

      return;
    }

    debugPrint('========================================');
    debugPrint('SUPERVISOR DEPARTMENT CHANGED');
    debugPrint('COMPANY ID = $companyId');
    debugPrint('DEPARTMENT ID = $departmentId');
    debugPrint('========================================');

    final notifier = ref.read(supervisorProvider.notifier);

    await notifier.selectDepartment(
      companyId: companyId,
      departmentId: departmentId,
    );
  }

  // ===============================================================
  // OPEN CREATE FORM
  // ===============================================================

  Future<void> _openCreateForm() async {
    final companyId = _currentCompanyId();

    if (companyId == null || companyId.isEmpty) {
      _showSnackBar('Current user company is not available.', isError: true);

      return;
    }

    final notifier = ref.read(supervisorProvider.notifier);

    // -------------------------------------------------------------
    // MAKE SURE DEPARTMENTS ARE AVAILABLE
    // -------------------------------------------------------------

    var state = ref.read(supervisorProvider);

    if (state.departments.isEmpty) {
      await notifier.loadDepartments(companyId);

      if (!mounted) {
        return;
      }
    }

    // -------------------------------------------------------------
    // RELOAD STATE
    // -------------------------------------------------------------

    state = ref.read(supervisorProvider);

    if (state.departments.isEmpty) {
      _showSnackBar(
        'No departments found for the current company.',
        isError: true,
      );

      return;
    }

    // -------------------------------------------------------------
    // OPEN FORM
    // -------------------------------------------------------------

    if (!mounted) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer(
          builder: (context, ref, child) {
            final currentState = ref.watch(supervisorProvider);

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: SupervisorPageForm(
                    state: currentState,
                    onDepartmentChanged: _onDepartmentChanged,
                    onSubmit: (Map<String, dynamic> data) async {
                      await _createSupervisor(data, dialogContext);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===============================================================
  // CREATE SUPERVISOR
  // ===============================================================

  Future<void> _createSupervisor(
    Map<String, dynamic> data,
    BuildContext dialogContext,
  ) async {
    final companyId = _currentCompanyId();

    if (companyId == null || companyId.isEmpty) {
      _showSnackBar('Current user company is not available.', isError: true);

      return;
    }

    final notifier = ref.read(supervisorProvider.notifier);

    final createData = <String, dynamic>{...data, 'company_id': companyId};

    debugPrint('========================================');
    debugPrint('SUPERVISOR CREATE');
    debugPrint('CREATE DATA = $createData');
    debugPrint('========================================');

    final success = await notifier.createSupervisor(createData);

    if (!mounted) {
      return;
    }

    if (!success) {
      final error = ref.read(supervisorProvider).errorMessage;

      _showSnackBar(
        error == null || error.trim().isEmpty
            ? 'Failed to create supervisor.'
            : error,
        isError: true,
      );

      return;
    }

    // -------------------------------------------------------------
    // CLOSE FORM
    // -------------------------------------------------------------

    if (dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
    }

    // -------------------------------------------------------------
    // REFRESH LIST
    // -------------------------------------------------------------

    await notifier.loadSupervisors(companyId);

    if (!mounted) {
      return;
    }

    _showSnackBar('Supervisor created successfully.');
  }

  // ===============================================================
  // REFRESH
  // ===============================================================

  Future<void> _refresh() async {
    final companyId = _currentCompanyId();

    if (companyId == null || companyId.isEmpty) {
      _showSnackBar('Current user company is not available.', isError: true);

      return;
    }

    final notifier = ref.read(supervisorProvider.notifier);

    debugPrint('SUPERVISOR REFRESH = $companyId');

    await notifier.selectCompany(companyId);
  }

  // ===============================================================
  // TOGGLE STATUS
  // ===============================================================

  Future<void> _toggleSupervisor(Map<String, dynamic> supervisor) async {
    final supervisorId = supervisor['id']?.toString();

    if (supervisorId == null || supervisorId.trim().isEmpty) {
      _showSnackBar('Invalid supervisor ID.', isError: true);

      return;
    }

    final isActive = supervisor['is_active'] == true;

    // -------------------------------------------------------------
    // EMPLOYEE NAME
    // -------------------------------------------------------------

    final employee = supervisor['employees'];

    String employeeName = 'this supervisor';

    if (employee is Map) {
      final fullName = employee['full_name']?.toString().trim();

      if (fullName != null && fullName.isNotEmpty) {
        employeeName = fullName;
      }
    }

    final action = isActive ? 'Deactivate' : 'Activate';

    // -------------------------------------------------------------
    // CONFIRM
    // -------------------------------------------------------------

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('$action Supervisor?'),
          content: Text(
            'Are you sure you want to '
            '${action.toLowerCase()} '
            '$employeeName?',
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(action),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    // -------------------------------------------------------------
    // UPDATE
    // -------------------------------------------------------------

    final notifier = ref.read(supervisorProvider.notifier);

    final success = await notifier.updateSupervisor({
      'id': supervisor['id'],
      'company_id': supervisor['company_id'],
      'department_id': supervisor['department_id'],
      'employee_id': supervisor['employee_id'],
      'is_active': !isActive,
    });

    if (!mounted) {
      return;
    }

    if (!success) {
      final error = ref.read(supervisorProvider).errorMessage;

      _showSnackBar(
        error == null || error.trim().isEmpty
            ? 'Failed to update supervisor.'
            : error,
        isError: true,
      );

      return;
    }

    _showSnackBar(
      isActive
          ? '$employeeName deactivated successfully.'
          : '$employeeName activated successfully.',
    );
  }

  // ===============================================================
  // DELETE SUPERVISOR
  // ===============================================================

  Future<void> _deleteSupervisor(Map<String, dynamic> supervisor) async {
    final supervisorId = supervisor['id']?.toString();

    if (supervisorId == null || supervisorId.trim().isEmpty) {
      _showSnackBar('Invalid supervisor ID.', isError: true);

      return;
    }

    // -------------------------------------------------------------
    // EMPLOYEE NAME
    // -------------------------------------------------------------

    final employee = supervisor['employees'];

    String employeeName = 'this supervisor';

    if (employee is Map) {
      final fullName = employee['full_name']?.toString().trim();

      if (fullName != null && fullName.isNotEmpty) {
        employeeName = fullName;
      }
    }

    // -------------------------------------------------------------
    // CONFIRM DELETE
    // -------------------------------------------------------------

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Supervisor'),
          content: Text(
            'Are you sure you want to delete '
            '$employeeName as a supervisor?',
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    // -------------------------------------------------------------
    // DELETE
    // -------------------------------------------------------------

    final notifier = ref.read(supervisorProvider.notifier);

    final success = await notifier.deleteSupervisor(supervisorId);

    if (!mounted) {
      return;
    }

    if (!success) {
      final error = ref.read(supervisorProvider).errorMessage;

      _showSnackBar(
        error == null || error.trim().isEmpty
            ? 'Failed to delete supervisor.'
            : error,
        isError: true,
      );

      return;
    }

    _showSnackBar('$employeeName deleted successfully.');
  }

  // ===============================================================
  // SNACKBAR
  // ===============================================================

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supervisorProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      // ===========================================================
      // APP BAR
      // ===========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        title: const Text(
          'Supervisor Management',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.isLoading ? null : _refresh,
            icon: const Icon(Icons.refresh, color: Colors.black87),
          ),
          const SizedBox(width: 8),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.black12),
        ),
      ),

      // ===========================================================
      // ADD
      // ===========================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isSaving ? null : _openCreateForm,
        icon: const Icon(Icons.add),
        label: const Text('Add Supervisor'),
      ),

      // ===========================================================
      // BODY
      // ===========================================================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCompanyInfo(state),

              const SizedBox(height: 16),

              Expanded(child: _buildContent(state)),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // COMPANY INFO
  // ===============================================================

  Widget _buildCompanyInfo(SupervisorState state) {
    final companyId = state.selectedCompanyId;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.business_outlined, color: Colors.blue),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Company',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    companyId == null || companyId.isEmpty
                        ? 'Company not available'
                        : 'Company selected',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (state.isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // CONTENT
  // ===============================================================

  Widget _buildContent(SupervisorState state) {
    // -------------------------------------------------------------
    // COMPANY NOT AVAILABLE
    // -------------------------------------------------------------

    if (state.selectedCompanyId == null || state.selectedCompanyId!.isEmpty) {
      return RefreshIndicator(
        onRefresh: _initialize,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Icon(Icons.business_outlined, size: 65, color: Colors.black38),
            SizedBox(height: 14),
            Center(
              child: Text(
                'Company not available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 6),
            Center(
              child: Text(
                'Current user company could not be loaded.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    }

    // -------------------------------------------------------------
    // LOADING
    // -------------------------------------------------------------

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // -------------------------------------------------------------
    // ERROR
    // -------------------------------------------------------------

    if (state.hasError) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 120),
            const Icon(Icons.error_outline, size: 55, color: Colors.red),
            const SizedBox(height: 12),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  state.errorMessage ?? 'Something went wrong.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      );
    }

    // -------------------------------------------------------------
    // EMPTY
    // -------------------------------------------------------------

    if (state.supervisors.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Icon(
              Icons.supervisor_account_outlined,
              size: 70,
              color: Colors.black26,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No supervisors found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 6),
            Center(
              child: Text(
                'Add a supervisor to this company.',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    }

    // -------------------------------------------------------------
    // SUPERVISOR LIST / TABLE
    // -------------------------------------------------------------

    return RefreshIndicator(
      onRefresh: _refresh,
      child: SupervisorTable(
        supervisors: state.supervisors,
        onToggleStatus: _toggleSupervisor,
        onDelete: _deleteSupervisor,
      ),
    );
  }
}

// =================================================================
// FORM ADAPTER
// =================================================================

class SupervisorPageForm extends StatelessWidget {
  final SupervisorState state;

  final Future<void> Function(String? departmentId) onDepartmentChanged;

  final Future<void> Function(Map<String, dynamic> data) onSubmit;

  const SupervisorPageForm({
    super.key,
    required this.state,
    required this.onDepartmentChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SupervisorForm(
      departments: state.departments,

      employees: state.employees,

      isSaving: state.isSaving,

      onDepartmentChanged: onDepartmentChanged,

      onSubmit: onSubmit,
    );
  }
}
