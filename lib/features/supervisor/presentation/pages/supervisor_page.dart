/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Management Page
///
/// Version : 6.0.0
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
/// - Theme aware
/// - Light / Dark mode supported
/// - Responsive mobile / tablet / desktop
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
  // BREAKPOINTS
  // ===============================================================

  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 1000;
  static const double _desktopMaxWidth = 1400;

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
  // RESPONSIVE
  // ===============================================================

  bool _isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < _mobileBreakpoint;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= _mobileBreakpoint && width < _tabletBreakpoint;
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= _tabletBreakpoint;
  }

  double _pageHorizontalPadding(BuildContext context) {
    if (_isMobile(context)) {
      return 12;
    }

    if (_isTablet(context)) {
      return 20;
    }

    return 24;
  }

  double _pageVerticalPadding(BuildContext context) {
    if (_isMobile(context)) {
      return 12;
    }

    return 20;
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
    } catch (e, stackTrace) {
      debugPrint('SUPERVISOR INITIALIZE ERROR = $e');

      debugPrint('STACK TRACE = $stackTrace');
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
    } catch (_) {
      // Property not available.
    }

    // -------------------------------------------------------------
    // company_id
    // -------------------------------------------------------------

    try {
      final value = user.company_id;

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    } catch (_) {
      // Property not available.
    }

    // -------------------------------------------------------------
    // MAP
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

    if (!mounted) {
      return;
    }

    // -------------------------------------------------------------
    // RESPONSIVE DIALOG
    // -------------------------------------------------------------

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer(
          builder: (context, ref, child) {
            final currentState = ref.watch(supervisorProvider);

            final screenWidth = MediaQuery.sizeOf(context).width;

            final screenHeight = MediaQuery.sizeOf(context).height;

            final isMobile = screenWidth < _mobileBreakpoint;

            final double dialogWidth = isMobile
                ? screenWidth - 24.0
                : screenWidth < _tabletBreakpoint
                ? screenWidth - 48.0
                : 620.0;

            final maxDialogHeight = screenHeight - 40;

            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 24,
                vertical: isMobile ? 12 : 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: dialogWidth,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxDialogHeight),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: SupervisorPageForm(
                      state: currentState,
                      onDepartmentChanged: _onDepartmentChanged,
                      onSubmit: (Map<String, dynamic> data) async {
                        await _createSupervisor(data, dialogContext);
                      },
                    ),
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
        final theme = Theme.of(dialogContext);

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
              style: FilledButton.styleFrom(
                backgroundColor: action == 'Deactivate'
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
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
        final theme = Theme.of(dialogContext);

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
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
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

    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: colorScheme.onInverseSurface,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError
              ? colorScheme.error
              : colorScheme.inverseSurface,
          margin: EdgeInsets.all(_isMobile(context) ? 12 : 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supervisorProvider);

    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final isMobile = _isMobile(context);

    final horizontalPadding = _pageHorizontalPadding(context);

    final verticalPadding = _pageVerticalPadding(context);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,

      // ===========================================================
      // APP BAR
      // ===========================================================
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        title: const Text(
          'Supervisor Management',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: state.isLoading ? null : _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
          SizedBox(width: isMobile ? 4 : 12),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant,
          ),
        ),
      ),

      // ===========================================================
      // ADD SUPERVISOR
      // ===========================================================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isSaving ? null : _openCreateForm,
        tooltip: 'Add Supervisor',
        icon: const Icon(Icons.add_rounded),
        label: Text(isMobile ? 'Add' : 'Add Supervisor'),
      ),

      // ===========================================================
      // BODY
      // ===========================================================
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _desktopMaxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                children: [
                  _buildCompanyInfo(state),

                  SizedBox(height: isMobile ? 12 : 18),

                  Expanded(child: _buildContent(state)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // COMPANY INFO
  // ===============================================================

  Widget _buildCompanyInfo(SupervisorState state) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final companyId = state.selectedCompanyId;

    final isAvailable = companyId != null && companyId.isNotEmpty;

    final isMobile = _isMobile(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Row(
          children: [
            Container(
              width: isMobile ? 42 : 48,
              height: isMobile ? 42 : 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.business_outlined,
                color: colorScheme.onPrimaryContainer,
                size: isMobile ? 21 : 24,
              ),
            ),

            SizedBox(width: isMobile ? 10 : 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Company',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    isAvailable ? 'Company selected' : 'Company not available',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            if (state.isLoading)
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: colorScheme.primary,
                ),
              )
            else if (isAvailable)
              Icon(
                Icons.check_circle_rounded,
                color: colorScheme.primary,
                size: 22,
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
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    // -------------------------------------------------------------
    // COMPANY NOT AVAILABLE
    // -------------------------------------------------------------

    if (state.selectedCompanyId == null || state.selectedCompanyId!.isEmpty) {
      return RefreshIndicator(
        onRefresh: _initialize,
        color: colorScheme.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildEmptyState(
              icon: Icons.business_outlined,
              title: 'Company not available',
              message: 'Current user company could not be loaded.',
            ),
          ],
        ),
      );
    }

    // -------------------------------------------------------------
    // LOADING
    // -------------------------------------------------------------

    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 14),
            Text(
              'Loading supervisors...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // -------------------------------------------------------------
    // ERROR
    // -------------------------------------------------------------

    if (state.hasError) {
      return RefreshIndicator(
        onRefresh: _refresh,
        color: colorScheme.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildErrorState(state.errorMessage ?? 'Something went wrong.'),
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
        color: colorScheme.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildEmptyState(
              icon: Icons.supervisor_account_outlined,
              title: 'No supervisors found',
              message: 'Add a supervisor to this company.',
            ),
          ],
        ),
      );
    }

    // -------------------------------------------------------------
    // SUPERVISOR TABLE
    // -------------------------------------------------------------

    return RefreshIndicator(
      onRefresh: _refresh,
      color: colorScheme.primary,
      child: SupervisorTable(
        supervisors: state.supervisors,
        onToggleStatus: _toggleSupervisor,
        onDelete: _deleteSupervisor,
      ),
    );
  }

  // ===============================================================
  // EMPTY STATE
  // ===============================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final isMobile = _isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 80 : 120,
      ),
      child: Column(
        children: [
          Container(
            width: isMobile ? 72 : 84,
            height: isMobile ? 72 : 84,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: isMobile ? 36 : 42,
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // ERROR STATE
  // ===============================================================

  Widget _buildErrorState(String message) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final isMobile = _isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 70 : 110,
      ),
      child: Column(
        children: [
          Container(
            width: isMobile ? 68 : 78,
            height: isMobile ? 68 : 78,
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: isMobile ? 34 : 40,
              color: colorScheme.onErrorContainer,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Something went wrong',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
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
