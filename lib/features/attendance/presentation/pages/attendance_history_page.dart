/// ===============================================================
/// Flutter HRMS Pro
/// Attendance History Page
///
/// Version : 2.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attendance_provider.dart';
import '../widgets/attendance_card.dart';
import '../widgets/attendance_empty_widget.dart';
import '../widgets/attendance_search_bar.dart';

class AttendanceHistoryPage extends ConsumerStatefulWidget {
  const AttendanceHistoryPage({
    super.key,
  });

  @override
  ConsumerState<AttendanceHistoryPage> createState() =>
      _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState
    extends ConsumerState<AttendanceHistoryPage> {
  // =============================================================
  // SEARCH CONTROLLER
  // =============================================================

  final TextEditingController _searchController =
  TextEditingController();

  // =============================================================
  // INITIALIZE
  // =============================================================

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(attendanceProvider.notifier)
          .loadAttendance();
    });
  }

  // =============================================================
  // REFRESH
  // =============================================================

  Future<void> _refresh() async {
    await ref
        .read(attendanceProvider.notifier)
        .refresh();
  }

  // =============================================================
  // RESPONSIVE CONTENT WIDTH
  // =============================================================

  double _contentMaxWidth(double width) {
    if (width >= 1400) {
      return 1100;
    }

    if (width >= 1000) {
      return 950;
    }

    if (width >= 700) {
      return 760;
    }

    return double.infinity;
  }

  // =============================================================
  // RESPONSIVE HORIZONTAL PADDING
  // =============================================================

  double _horizontalPadding(double width) {
    if (width >= 1200) {
      return 28;
    }

    if (width >= 700) {
      return 22;
    }

    return 14;
  }

  // =============================================================
  // SEARCH SECTION
  // =============================================================

  Widget _buildSearchSection(
      BuildContext context,
      double width,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final horizontalPadding =
    _horizontalPadding(width);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        14,
        horizontalPadding,
        12,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant
                .withOpacity(.55),
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _contentMaxWidth(width),
          ),
          child: AttendanceSearchBar(
            controller: _searchController,
            onChanged: (value) {
              ref
                  .read(
                attendanceProvider.notifier,
              )
                  .search(value);
            },
          ),
        ),
      ),
    );
  }

  // =============================================================
  // ERROR VIEW
  // =============================================================

  Widget _buildErrorView(
      BuildContext context,
      Object error,
      double width,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(
          width >= 700 ? 32 : 20,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Card(
            elevation: 0,
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(
                width >= 700 ? 32 : 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colorScheme.error
                          .withOpacity(.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 34,
                      color: colorScheme.error,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Something went wrong',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 20),

                  FilledButton.icon(
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
          ),
        ),
      ),
    );
  }

  // =============================================================
  // LOADING VIEW
  // =============================================================

  Widget _buildLoadingView(
      BuildContext context,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Loading attendance...',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
              colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // EMPTY VIEW
  // =============================================================

  Widget _buildEmptyView(
      BuildContext context,
      double width,
      ) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics:
        const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal:
          _horizontalPadding(width),
        ),
        children: [
          SizedBox(
            height: width >= 700 ? 180 : 150,
          ),

          const AttendanceEmptyWidget(),

          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ATTENDANCE LIST
  // =============================================================

  Widget _buildAttendanceList(
      BuildContext context,
      List attendanceList,
      double width,
      ) {
    final horizontalPadding =
    _horizontalPadding(width);

    return RefreshIndicator(
      onRefresh: _refresh,

      child: ListView.builder(
        physics:
        const AlwaysScrollableScrollPhysics(),

        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          14,
          horizontalPadding,
          28,
        ),

        itemCount:
        attendanceList.length,

        itemBuilder:
            (context, index) {
          final attendance =
          attendanceList[index];

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                _contentMaxWidth(width),
              ),
              child: Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 12,
                ),
                child: AttendanceCard(
                  attendance:
                  attendance,

                  // ------------------------------------------------
                  // DETAILS
                  // ------------------------------------------------

                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/attendance/details',
                      arguments:
                      attendance,
                    );
                  },

                  // ------------------------------------------------
                  // EDIT
                  // ------------------------------------------------

                  onEdit: () async {
                    final result =
                    await Navigator.pushNamed(
                      context,
                      '/attendance/edit',
                      arguments:
                      attendance,
                    );

                    if (result == true) {
                      await _refresh();
                    }
                  },

                  // ------------------------------------------------
                  // DELETE
                  // ------------------------------------------------

                  onDelete: () async {
                    final id =
                        attendance.id;

                    if (id == null ||
                        id.trim().isEmpty) {
                      return;
                    }

                    final success =
                    await ref
                        .read(
                      attendanceProvider
                          .notifier,
                    )
                        .delete(id);

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        behavior:
                        SnackBarBehavior.floating,
                        content: Text(
                          success
                              ? 'Attendance deleted successfully.'
                              : 'Failed to delete attendance.',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final attendanceState =
    ref.watch(attendanceProvider);

    final mediaQuery =
    MediaQuery.sizeOf(context);

    final width =
        mediaQuery.width;

    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Scaffold(
      backgroundColor:
      colorScheme.surfaceContainerLowest,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        title: const Text(
          'Attendance History',
        ),
        centerTitle: true,

        elevation: 0,

        backgroundColor:
        colorScheme.surface,

        foregroundColor:
        colorScheme.onSurface,

        surfaceTintColor:
        colorScheme.surfaceTint,
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: Column(
        children: [
          // =======================================================
          // SEARCH
          // =======================================================

          _buildSearchSection(
            context,
            width,
          ),

          // =======================================================
          // ATTENDANCE LIST
          // =======================================================

          Expanded(
            child: attendanceState.when(
              // ---------------------------------------------------
              // LOADING
              // ---------------------------------------------------

              loading: () {
                return _buildLoadingView(
                  context,
                );
              },

              // ---------------------------------------------------
              // ERROR
              // ---------------------------------------------------

              error: (
                  error,
                  stackTrace,
                  ) {
                return _buildErrorView(
                  context,
                  error,
                  width,
                );
              },

              // ---------------------------------------------------
              // DATA
              // ---------------------------------------------------

              data: (
                  attendanceList,
                  ) {
                // -------------------------------------------------
                // EMPTY
                // -------------------------------------------------

                if (attendanceList.isEmpty) {
                  return _buildEmptyView(
                    context,
                    width,
                  );
                }

                // -------------------------------------------------
                // LIST
                // -------------------------------------------------

                return _buildAttendanceList(
                  context,
                  attendanceList,
                  width,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}