/// ===============================================================
/// Flutter HRMS Pro
/// Supervisor Department Status Page
///
/// File:
/// supervisor_department_status_page.dart
///
/// Version : 3.0.0
///
/// Purpose:
/// - Company is NOT selected manually
/// - Company ID comes from logged-in user
/// - SelectCompany is automatically called using current user's companyId
/// - Show departments without supervisor assignment
/// - Show supervisor-wise assigned departments
/// - Show supervisor name
/// - Show assigned department names
/// - Refresh status
///
/// UI:
/// - Theme aware
/// - Light / Dark mode compatible
/// - Mobile responsive
/// - Tablet responsive
/// - Desktop responsive
/// - Adaptive summary cards
/// - Adaptive page spacing
/// - Adaptive tabs
/// - Adaptive supervisor cards
///
/// Company source:
/// currentUserProvider -> CurrentUser.companyId
///
/// Existing Supervisor Provider / Notifier is used.
/// No existing Supervisor CRUD page is modified.
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user_provider.dart';
import '../providers/supervisor_provider.dart';
import '../providers/supervisor_state.dart';

class SupervisorDepartmentStatusPage extends ConsumerStatefulWidget {
  const SupervisorDepartmentStatusPage({super.key});

  @override
  ConsumerState<SupervisorDepartmentStatusPage> createState() =>
      _SupervisorDepartmentStatusPageState();
}

class _SupervisorDepartmentStatusPageState
    extends ConsumerState<SupervisorDepartmentStatusPage>
    with SingleTickerProviderStateMixin {
  // =============================================================
  // RESPONSIVE BREAKPOINTS
  // =============================================================

  static const double _mobileBreakpoint = 600.0;
  static const double _tabletBreakpoint = 900.0;
  static const double _desktopBreakpoint = 1200.0;

  // =============================================================
  // LOADING STATUS DATA
  // =============================================================

  bool _isLoadingStatus = false;

  // =============================================================
  // INITIALIZATION
  // =============================================================

  bool _isInitialized = false;

  // =============================================================
  // CURRENT COMPANY ID
  // =============================================================

  String? get _companyId {
    final user = ref.read(currentUserProvider);

    if (user == null) {
      return null;
    }

    final companyId = user.companyId.trim();

    if (companyId.isEmpty) {
      return null;
    }

    return companyId;
  }

  // =============================================================
  // STATUS DATA
  // =============================================================

  List<Map<String, dynamic>> _supervisorStatus =
  <Map<String, dynamic>>[];

  // =============================================================
  // NOT ASSIGNED DEPARTMENTS
  // =============================================================

  List<Map<String, dynamic>> _notAssignedDepartments =
  <Map<String, dynamic>>[];

  // =============================================================
  // TAB CONTROLLER
  // =============================================================

  late TabController _tabController;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    Future.microtask(_initialize);
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // =============================================================
  // INITIALIZE
  // =============================================================

  Future<void> _initialize() async {
    if (!mounted) {
      return;
    }

    final companyId = _companyId;

    if (companyId == null || companyId.isEmpty) {
      return;
    }

    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    await ref
        .read(supervisorProvider.notifier)
        .selectCompany(companyId);

    if (!mounted) {
      return;
    }

    await _loadStatus();
  }

  // =============================================================
  // CLEAR STATUS DATA
  // =============================================================

  void _clearStatusData() {
    _supervisorStatus = <Map<String, dynamic>>[];
    _notAssignedDepartments = <Map<String, dynamic>>[];
  }

  // =============================================================
  // LOAD STATUS
  // =============================================================

  Future<void> _loadStatus() async {
    final companyId = _companyId;

    if (companyId == null || companyId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
          _clearStatusData();
        });
      }

      return;
    }

    final state = ref.read(supervisorProvider);

    if (mounted) {
      setState(() {
        _isLoadingStatus = true;
        _clearStatusData();
      });
    }

    try {
      // =========================================================
      // DEPARTMENT MAP
      // =========================================================

      final Map<String, Map<String, dynamic>> departmentMap =
      <String, Map<String, dynamic>>{};

      for (final department in state.departments) {
        final id = department['id']?.toString().trim();

        if (id == null || id.isEmpty) {
          continue;
        }

        departmentMap[id] = department;
      }

      // =========================================================
      // SUPERVISOR STATUS
      // =========================================================

      final List<Map<String, dynamic>> supervisorStatus =
      <Map<String, dynamic>>[];

      final Set<String> assignedDepartmentIds = <String>{};

      // =========================================================
      // LOOP THROUGH SUPERVISORS
      // =========================================================

      for (final supervisor in state.supervisors) {
        final supervisorId = supervisor['id']?.toString().trim();

        if (supervisorId == null || supervisorId.isEmpty) {
          continue;
        }

        final supervisorName = _supervisorName(supervisor);

        final assignments = await ref
            .read(supervisorProvider.notifier)
            .loadSupervisorDepartmentAssignments(
          companyId: companyId,
          supervisorId: supervisorId,
        );

        final List<String> departmentIds = <String>[];
        final List<String> departmentNames = <String>[];

        for (final assignment in assignments) {
          final departmentId =
          assignment['department_id']?.toString().trim();

          if (departmentId == null || departmentId.isEmpty) {
            continue;
          }

          if (!departmentIds.contains(departmentId)) {
            departmentIds.add(departmentId);
          }

          assignedDepartmentIds.add(departmentId);

          final department = departmentMap[departmentId];

          final departmentName =
          department?['name']?.toString().trim();

          if (departmentName != null &&
              departmentName.isNotEmpty &&
              !departmentNames.contains(departmentName)) {
            departmentNames.add(departmentName);
          }
        }

        supervisorStatus.add(
          <String, dynamic>{
            'supervisor_id': supervisorId,
            'supervisor_name': supervisorName,
            'department_ids': departmentIds,
            'department_names': departmentNames,
          },
        );
      }

      // =========================================================
      // FIND NOT ASSIGNED DEPARTMENTS
      // =========================================================

      final List<Map<String, dynamic>> notAssigned =
      <Map<String, dynamic>>[];

      for (final department in state.departments) {
        final departmentId = department['id']?.toString().trim();

        if (departmentId == null || departmentId.isEmpty) {
          continue;
        }

        if (!assignedDepartmentIds.contains(departmentId)) {
          notAssigned.add(department);
        }
      }

      // =========================================================
      // UPDATE UI
      // =========================================================

      if (!mounted) {
        return;
      }

      setState(() {
        _supervisorStatus = supervisorStatus;
        _notAssignedDepartments = notAssigned;
        _isLoadingStatus = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingStatus = false;
      });

      _showMessage(
        'Unable to load supervisor department status.',
      );
    }
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

    final name =
    '$firstName $lastName'.trim();

    if (name.isEmpty) {
      return 'Unknown Supervisor';
    }

    return name;
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
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    final companyId = _companyId;

    if (companyId == null || companyId.isEmpty) {
      _showMessage(
        'Company information was not found for the logged-in user.',
      );

      return;
    }

    if (_isLoadingStatus) {
      return;
    }

    if (mounted) {
      setState(() {
        _clearStatusData();
      });
    }

    await ref
        .read(supervisorProvider.notifier)
        .selectCompany(companyId);

    if (!mounted) {
      return;
    }

    await _loadStatus();
  }

  // =============================================================
  // MESSAGE
  // =============================================================

  void _showMessage(String message) {
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
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supervisorProvider);
    final user = ref.watch(currentUserProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

        titleSpacing: 16,

        title: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile =
                MediaQuery.sizeOf(context).width <
                    _mobileBreakpoint;

            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Supervisor Department Status',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Department assignment status',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 11,
                    color:
                    colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          },
        ),

        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
            _isLoadingStatus || user == null
                ? null
                : _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),

          const SizedBox(width: 4),
        ],
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: _buildBody(
          state,
          user,
        ),
      ),
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody(
      SupervisorState state,
      dynamic user,
      ) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isMobile =
        screenWidth < _mobileBreakpoint;

    final isTablet =
        screenWidth >= _mobileBreakpoint &&
            screenWidth < _tabletBreakpoint;

    final horizontalPadding = isMobile
        ? 12.0
        : isTablet
        ? 20.0
        : 28.0;

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final companyId =
        user.companyId?.toString().trim() ?? '';

    if (companyId.isEmpty) {
      return _buildNoCompanyState();
    }

    if ((state.isLoading ||
        _isLoadingStatus) &&
        state.departments.isEmpty &&
        state.supervisors.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),

          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            isMobile ? 14.0 : 20.0,
            horizontalPadding,
            isMobile ? 24.0 : 32.0,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _desktopBreakpoint,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  _buildPageHeader(),

                  SizedBox(
                    height: isMobile
                        ? 14.0
                        : 20.0,
                  ),

                  _buildStatusSection(
                    state,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =============================================================
  // PAGE HEADER
  // =============================================================

  Widget _buildPageHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isMobile =
        screenWidth < _mobileBreakpoint;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Department Assignment Status',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: isMobile ? 19.0 : 22.0,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'View supervisor and department assignments for your company.',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: isMobile ? 11.0 : 12.0,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // NO COMPANY STATE
  // =============================================================

  Widget _buildNoCompanyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 430.0,
          ),
          child: _card(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business_outlined,
                    size: 32.0,
                    color:
                    colorScheme.onErrorContainer,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Company information not found',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'The logged-in user is not associated with a company.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                    colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 20),

                FilledButton.icon(
                  onPressed: _initialize,
                  icon: const Icon(
                    Icons.refresh_rounded,
                  ),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // STATUS SECTION
  // =============================================================

  Widget _buildStatusSection(
      SupervisorState state,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isMobile =
        screenWidth < _mobileBreakpoint;

    return _card(
      padding: EdgeInsets.all(
        isMobile ? 12.0 : 18.0,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =====================================================
          // HEADER
          // =====================================================

          _buildSectionHeader(),

          SizedBox(
            height: isMobile
                ? 14.0
                : 18.0,
          ),

          // =====================================================
          // SUMMARY
          // =====================================================

          _buildSummary(state),

          SizedBox(
            height: isMobile
                ? 14.0
                : 18.0,
          ),

          // =====================================================
          // TABS
          // =====================================================

          _buildTabs(),

          SizedBox(
            height: isMobile
                ? 14.0
                : 18.0,
          ),

          // =====================================================
          // TAB CONTENT
          // =====================================================

          AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              if (_isLoadingStatus) {
                return Padding(
                  padding: EdgeInsets.all(
                    isMobile ? 28.0 : 40.0,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                );
              }

              if (_tabController.index == 0) {
                return _buildNotAssignedTab();
              }

              return _buildSupervisorDepartmentsTab();
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SECTION HEADER
  // =============================================================

  Widget _buildSectionHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isMobile =
        screenWidth < _mobileBreakpoint;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: [
        Container(
          width: isMobile ? 40.0 : 44.0,
          height: isMobile ? 40.0 : 44.0,
          decoration: BoxDecoration(
            color:
            colorScheme.primaryContainer,
            borderRadius:
            BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.analytics_outlined,
            color:
            colorScheme.onPrimaryContainer,
            size: isMobile ? 21.0 : 23.0,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Department Assignment Status',
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style:
                theme.textTheme.titleMedium?.copyWith(
                  fontSize:
                  isMobile ? 14.0 : 16.0,
                  fontWeight:
                  FontWeight.w700,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Check supervisor and department assignments.',
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                style:
                theme.textTheme.bodySmall?.copyWith(
                  fontSize:
                  isMobile ? 10.0 : 11.0,
                  color: colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================
  // TABS
  // =============================================================

  Widget _buildTabs() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isMobile =
        screenWidth < _mobileBreakpoint;

    return Container(
      height: isMobile ? 44.0 : 48.0,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,

        labelColor: colorScheme.primary,

        unselectedLabelColor:
        colorScheme.onSurfaceVariant,

        labelStyle: TextStyle(
          fontSize: isMobile ? 10.5 : 12.0,
          fontWeight: FontWeight.w700,
        ),

        unselectedLabelStyle: TextStyle(
          fontSize: isMobile ? 10.5 : 12.0,
          fontWeight: FontWeight.w500,
        ),

        indicator: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow
                  .withValues(alpha: .08),
              blurRadius: 5.0,
              offset: const Offset(0, 1),
            ),
          ],
        ),

        indicatorSize:
        TabBarIndicatorSize.tab,

        dividerColor:
        Colors.transparent,

        splashBorderRadius:
        BorderRadius.circular(9),

        tabs: [
          Tab(
            text:
            'Not Assigned (${_notAssignedDepartments.length})',
          ),

          Tab(
            text:
            'Supervisors (${_supervisorStatus.length})',
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SUMMARY
  // =============================================================

  Widget _buildSummary(
      SupervisorState state,
      ) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isMobile =
        screenWidth < _mobileBreakpoint;

    final isTablet =
        screenWidth >= _mobileBreakpoint &&
            screenWidth < _tabletBreakpoint;

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  icon:
                  Icons.apartment_outlined,
                  title: 'Departments',
                  value:
                  state.departments.length
                      .toString(),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _summaryCard(
                  icon: Icons
                      .supervisor_account_outlined,
                  title: 'Supervisors',
                  value:
                  state.supervisors.length
                      .toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          _summaryCard(
            icon:
            Icons.warning_amber_outlined,
            title: 'Not Assigned',
            value:
            _notAssignedDepartments.length
                .toString(),
            fullWidth: true,
          ),
        ],
      );
    }

    if (isTablet) {
      return Row(
        children: [
          Expanded(
            child: _summaryCard(
              icon:
              Icons.apartment_outlined,
              title: 'Departments',
              value:
              state.departments.length
                  .toString(),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _summaryCard(
              icon: Icons
                  .supervisor_account_outlined,
              title: 'Supervisors',
              value:
              state.supervisors.length
                  .toString(),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: _summaryCard(
              icon:
              Icons.warning_amber_outlined,
              title: 'Not Assigned',
              value:
              _notAssignedDepartments
                  .length
                  .toString(),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            icon:
            Icons.apartment_outlined,
            title: 'Departments',
            value:
            state.departments.length
                .toString(),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _summaryCard(
            icon: Icons
                .supervisor_account_outlined,
            title: 'Supervisors',
            value:
            state.supervisors.length
                .toString(),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _summaryCard(
            icon:
            Icons.warning_amber_outlined,
            title: 'Not Assigned',
            value:
            _notAssignedDepartments
                .length
                .toString(),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // SUMMARY CARD
  // =============================================================

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    bool fullWidth = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isMobile =
        screenWidth < _mobileBreakpoint;

    return Container(
      width: fullWidth
          ? double.infinity
          : null,

      padding: EdgeInsets.all(
        isMobile ? 11.0 : 14.0,
      ),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: isMobile
                ? 34.0
                : 38.0,
            height: isMobile
                ? 34.0
                : 38.0,
            decoration: BoxDecoration(
              color:
              colorScheme.primaryContainer,
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: isMobile
                  ? 18.0
                  : 20.0,
              color:
              colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  theme.textTheme.titleLarge?.copyWith(
                    fontSize:
                    isMobile ? 18.0 : 21.0,
                    fontWeight:
                    FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  theme.textTheme.bodySmall?.copyWith(
                    fontSize:
                    isMobile ? 9.5 : 10.5,
                    color: colorScheme
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

  // =============================================================
  // TAB 1
  // NOT ASSIGNED DEPARTMENTS
  // =============================================================

  Widget _buildNotAssignedTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_notAssignedDepartments.isEmpty) {
      return _buildEmptyState(
        icon:
        Icons.check_circle_outline,
        title:
        'All departments are assigned',
        subtitle:
        'Every department has at least one supervisor.',
        iconColor:
        colorScheme.tertiary,
      );
    }

    return Column(
      children:
      _notAssignedDepartments.map(
            (department) {
          final name =
          department['name']
              ?.toString()
              .trim();

          return _buildNotAssignedCard(
            name: name == null ||
                name.isEmpty
                ? 'Unnamed Department'
                : name,
          );
        },
      ).toList(),
    );
  }

  // =============================================================
  // NOT ASSIGNED CARD
  // =============================================================

  Widget _buildNotAssignedCard({
    required String name,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(bottom: 8),
      padding:
      const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
        colorScheme.errorContainer
            .withValues(alpha: .45),
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color:
          colorScheme.error
              .withValues(alpha: .20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              color:
              colorScheme.errorContainer,
              borderRadius:
              BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.apartment_outlined,
              color:
              colorScheme.onErrorContainer,
              size: 20.0,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.5,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'No supervisor assigned',
                  style:
                  theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color:
                    colorScheme.error,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Icon(
            Icons.warning_amber_outlined,
            color:
            colorScheme.error,
            size: 20,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // TAB 2
  // SUPERVISOR DEPARTMENTS
  // =============================================================

  Widget _buildSupervisorDepartmentsTab() {
    if (_supervisorStatus.isEmpty) {
      final colorScheme =
          Theme.of(context).colorScheme;

      return _buildEmptyState(
        icon:
        Icons.supervisor_account_outlined,
        title:
        'No supervisors found',
        subtitle:
        'There are no supervisors for this company.',
        iconColor:
        colorScheme.onSurfaceVariant,
      );
    }

    return Column(
      children:
      _supervisorStatus.map(
            (item) {
          return _buildSupervisorCard(
            item,
          );
        },
      ).toList(),
    );
  }

  // =============================================================
  // SUPERVISOR CARD
  // =============================================================

  Widget _buildSupervisorCard(
      Map<String, dynamic> item,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final supervisorName =
        item['supervisor_name']
            ?.toString()
            .trim() ??
            'Unknown Supervisor';

    final departmentNames =
        (item['department_names'] as List?)
            ?.map(
              (e) => e.toString(),
        )
            .toList() ??
            <String>[];

    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(bottom: 10),
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
        BorderRadius.circular(13),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =====================================================
          // SUPERVISOR HEADER
          // =====================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color:
                  colorScheme.primaryContainer,
                  borderRadius:
                  BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons
                      .supervisor_account_outlined,
                  color:
                  colorScheme.onPrimaryContainer,
                  size: 23.0,
                ),
              ),

              const SizedBox(width: 11),

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
                      style:
                      theme.textTheme.titleSmall?.copyWith(
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      '${departmentNames.length} department(s) assigned',
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(
            height: 1,
            color:
            colorScheme.outlineVariant,
          ),

          const SizedBox(height: 12),

          // =====================================================
          // DEPARTMENTS
          // =====================================================

          if (departmentNames.isEmpty)
            _buildNoDepartmentAssigned()
          else
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children:
              departmentNames.map(
                    (name) {
                  return _buildDepartmentChip(
                    name,
                  );
                },
              ).toList(),
            ),
        ],
      ),
    );
  }

  // =============================================================
  // NO DEPARTMENT ASSIGNED
  // =============================================================

  Widget _buildNoDepartmentAssigned() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
        colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(10),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color:
            colorScheme.onSurfaceVariant,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              'No department assigned.',
              style:
              theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color:
                colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DEPARTMENT CHIP
  // =============================================================

  Widget _buildDepartmentChip(
      String name,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints:
      const BoxConstraints(
        maxWidth: 280.0,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color:
        colorScheme.secondaryContainer,
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color:
          colorScheme.secondary
              .withValues(alpha: .18),
        ),
      ),
      child: Row(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          Icon(
            Icons.apartment_outlined,
            size: 14,
            color:
            colorScheme.onSecondaryContainer,
          ),

          const SizedBox(width: 5),

          Flexible(
            child: Text(
              name,
              maxLines: 2,
              overflow:
              TextOverflow.ellipsis,
              style:
              theme.textTheme.labelMedium?.copyWith(
                fontSize: 10.5,
                fontWeight:
                FontWeight.w600,
                color: colorScheme
                    .onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // EMPTY STATE
  // =============================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final isMobile =
        screenWidth < _mobileBreakpoint;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile ? 24.0 : 30.0,
      ),
      decoration: BoxDecoration(
        color:
        colorScheme.surfaceContainerLow,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58.0,
            height: 58.0,
            decoration: BoxDecoration(
              color: iconColor
                  .withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30.0,
              color: iconColor,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,
            style:
            theme.textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight:
              FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style:
            theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color:
              colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // CARD
  // =============================================================

  Widget _card({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding:
      padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
        BorderRadius.circular(14),
        border: Border.all(
          color:
          colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color:
            colorScheme.shadow.withValues(
              alpha: theme.brightness ==
                  Brightness.dark
                  ? .10
                  : .04,
            ),
            blurRadius: 10.0,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  Widget _buildError(
      SupervisorState state,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints:
          const BoxConstraints(
            maxWidth: 430.0,
          ),
          child: _card(
            padding:
            const EdgeInsets.all(28),
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color:
                    colorScheme.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 32.0,
                    color: colorScheme
                        .onErrorContainer,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  state.errorMessage ??
                      'Something went wrong.',
                  textAlign:
                  TextAlign.center,
                  style:
                  theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 18),

                FilledButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                  ),
                  label:
                  const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}