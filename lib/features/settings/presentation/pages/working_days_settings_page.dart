/// ===============================================================
/// Flutter HRMS Pro
///
/// Working Days Settings Page
///
/// Version : 1.2.0
///
/// Features:
/// - Company-wise working days
/// - No company dropdown
/// - Uses logged-in user's company
/// - Responsive UI
/// - Light / Dark / System theme aware
/// - Save working-day configuration
/// - Quick working-day actions
/// - Success / Error feedback
/// - Mobile / Tablet / Desktop friendly
/// - Safe bottom action layout
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/services/supabase_service.dart';

class WorkingDaysSettingsPage extends ConsumerStatefulWidget {
  const WorkingDaysSettingsPage({
    super.key,
  });

  @override
  ConsumerState<WorkingDaysSettingsPage> createState() =>
      _WorkingDaysSettingsPageState();
}

class _WorkingDaysSettingsPageState
    extends ConsumerState<WorkingDaysSettingsPage> {
  // =============================================================
  // STATE
  // =============================================================

  bool isLoading = true;
  bool isSaving = false;

  String? errorMessage;

  // =============================================================
  // WORKING DAYS
  // =============================================================

  final List<_WorkingDay> days = [
    _WorkingDay(
      dayNumber: 1,
      name: 'Monday',
      shortName: 'Mon',
      isWorkingDay: true,
    ),
    _WorkingDay(
      dayNumber: 2,
      name: 'Tuesday',
      shortName: 'Tue',
      isWorkingDay: true,
    ),
    _WorkingDay(
      dayNumber: 3,
      name: 'Wednesday',
      shortName: 'Wed',
      isWorkingDay: true,
    ),
    _WorkingDay(
      dayNumber: 4,
      name: 'Thursday',
      shortName: 'Thu',
      isWorkingDay: true,
    ),
    _WorkingDay(
      dayNumber: 5,
      name: 'Friday',
      shortName: 'Fri',
      isWorkingDay: true,
    ),
    _WorkingDay(
      dayNumber: 6,
      name: 'Saturday',
      shortName: 'Sat',
      isWorkingDay: false,
    ),
    _WorkingDay(
      dayNumber: 7,
      name: 'Sunday',
      shortName: 'Sun',
      isWorkingDay: false,
    ),
  ];

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWorkingDays();
    });
  }

  // =============================================================
  // LOAD WORKING DAYS
  // =============================================================

  Future<void> _loadWorkingDays() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // =========================================================
      // CURRENT USER
      // =========================================================

      final CurrentUser? user =
      ref.read(currentUserProvider);

      if (user == null) {
        throw Exception(
          'Logged-in user information was not found.',
        );
      }

      // =========================================================
      // COMPANY ID
      // =========================================================

      final String? companyId = user.companyId;

      if (companyId == null ||
          companyId.trim().isEmpty) {
        throw Exception(
          'Company ID was not found for the logged-in user.',
        );
      }

      // =========================================================
      // SUPABASE QUERY
      // =========================================================

      final response =
      await SupabaseService.client
          .from('company_working_days')
          .select(
        'day_of_week, is_working_day',
      )
          .eq(
        'company_id',
        companyId,
      )
          .order(
        'day_of_week',
      );

      // =========================================================
      // RESPONSE
      // =========================================================

      final List<Map<String, dynamic>> rows =
      List<Map<String, dynamic>>.from(
        response,
      );

      // =========================================================
      // APPLY DATABASE VALUES
      // =========================================================

      for (final day in days) {
        Map<String, dynamic>? matchedRow;

        for (final row in rows) {
          if (row['day_of_week'] == day.dayNumber) {
            matchedRow = row;
            break;
          }
        }

        if (matchedRow != null) {
          day.isWorkingDay =
              matchedRow['is_working_day'] == true;
        }
      }

      // =========================================================
      // COMPLETE
      // =========================================================

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // =============================================================
  // SAVE WORKING DAYS
  // =============================================================

  Future<void> _saveWorkingDays() async {
    if (isSaving) {
      return;
    }

    try {
      // =========================================================
      // CURRENT USER
      // =========================================================

      final CurrentUser? user =
      ref.read(currentUserProvider);

      if (user == null) {
        throw Exception(
          'Logged-in user information was not found.',
        );
      }

      // =========================================================
      // COMPANY ID
      // =========================================================

      final String? companyId = user.companyId;

      if (companyId == null ||
          companyId.trim().isEmpty) {
        throw Exception(
          'Company ID was not found for the logged-in user.',
        );
      }

      // =========================================================
      // START SAVING
      // =========================================================

      setState(() {
        isSaving = true;
        errorMessage = null;
      });

      // =========================================================
      // PAYLOAD
      // =========================================================

      final List<Map<String, dynamic>> payload =
      days.map((day) {
        return {
          'company_id': companyId,
          'day_of_week': day.dayNumber,
          'is_working_day': day.isWorkingDay,
        };
      }).toList();

      // =========================================================
      // UPSERT
      // =========================================================

      await SupabaseService.client
          .from('company_working_days')
          .upsert(
        payload,
        onConflict: 'company_id,day_of_week',
      );

      // =========================================================
      // COMPLETE
      // =========================================================

      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
      });

      _showSuccessSnackBar(
        'Working days saved successfully.',
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
        errorMessage = e.toString();
      });

      _showErrorSnackBar(
        'Failed to save working days.\n$e',
      );
    }
  }

  // =============================================================
  // SUCCESS SNACKBAR
  // =============================================================

  void _showSuccessSnackBar(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final messenger =
    ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor:
          colorScheme.inverseSurface,
          elevation: 0,
          duration: const Duration(
            seconds: 3,
          ),
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color:
                colorScheme.onInverseSurface,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                    colorScheme.onInverseSurface,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // =============================================================
  // ERROR SNACKBAR
  // =============================================================

  void _showErrorSnackBar(
      String message,
      ) {
    if (!mounted) {
      return;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final messenger =
    ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          backgroundColor:
          colorScheme.error,
          elevation: 0,
          duration: const Duration(
            seconds: 4,
          ),
          content: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: colorScheme.onError,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                    colorScheme.onError,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
              ),
            ],
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
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Scaffold(
      backgroundColor:
      colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor:
        colorScheme.surface,
        foregroundColor:
        colorScheme.onSurface,

        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Working Days',
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // BODY
      //
      // IMPORTANT:
      // bottomNavigationBar ব্যবহার করছি না।
      //
      // এতে Floating SnackBar + bottomNavigationBar
      // conflict হবে না।
      // =========================================================

      body: SafeArea(
        child: Column(
          children: [
            // ===================================================
            // CONTENT
            // ===================================================

            Expanded(
              child: isLoading
                  ? _buildLoading()
                  : _buildBody(),
            ),

            // ===================================================
            // SAVE BUTTON
            // ===================================================

            if (!isLoading)
              _buildBottomSaveButton(),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // LOADING
  // =============================================================

  Widget _buildLoading() {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color:
            colorScheme.primary,
          ),

          const SizedBox(
            height: 14,
          ),

          Text(
            'Loading working days...',
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // BODY
  // =============================================================

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final double width =
            constraints.maxWidth;

        // =======================================================
        // RESPONSIVE
        // =======================================================

        final bool isDesktop =
            width >= 1000;

        final bool isTablet =
            width >= 600;

        final double horizontalPadding =
        isDesktop
            ? 32
            : isTablet
            ? 24
            : 14;

        return SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),

          padding:
          EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
            24,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 760,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // =================================================
                  // HEADER
                  // =================================================

                  _buildHeader(),

                  const SizedBox(
                    height: 16,
                  ),

                  // =================================================
                  // ERROR
                  // =================================================

                  if (errorMessage != null)
                    _buildError(),

                  // =================================================
                  // WORKING DAYS
                  // =================================================

                  _buildWorkingDaysCard(),

                  const SizedBox(
                    height: 16,
                  ),

                  // =================================================
                  // INFORMATION
                  // =================================================

                  _buildInformationCard(),

                  // =================================================
                  // EXTRA BOTTOM SPACE
                  // =================================================

                  const SizedBox(
                    height: 24,
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
  // HEADER
  // =============================================================

  Widget _buildHeader() {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final primary =
        colorScheme.primary;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(
        color: colorScheme
            .primaryContainer
            .withOpacity(.55),

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color: primary
              .withOpacity(.15),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // =====================================================
          // ICON
          // =====================================================

          Container(
            width: 52,
            height: 52,

            decoration:
            BoxDecoration(
              color: primary
                  .withOpacity(.12),

              borderRadius:
              BorderRadius.circular(
                14,
              ),
            ),

            child: Icon(
              Icons
                  .calendar_month_outlined,
              color: primary,
              size: 27,
            ),
          ),

          const SizedBox(
            width: 13,
          ),

          // =====================================================
          // TEXT
          // =====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  'Working Days',
                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Configure the weekly working schedule for your company.',
                  maxLines: 3,
                  overflow:
                  TextOverflow.ellipsis,

                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    height: 1.4,
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
  // WORKING DAYS CARD
  // =============================================================

  Widget _buildWorkingDaysCard() {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(16),

      decoration:
      BoxDecoration(
        color: colorScheme
            .surfaceContainerLow,

        borderRadius:
        BorderRadius.circular(18),

        border: Border.all(
          color:
          colorScheme
              .outlineVariant,
        ),
      ),

      child: Column(
        children: [
          // =====================================================
          // TITLE
          // =====================================================

          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration:
                BoxDecoration(
                  color: colorScheme
                      .primaryContainer,

                  borderRadius:
                  BorderRadius.circular(
                    11,
                  ),
                ),

                child: Icon(
                  Icons
                      .work_outline_rounded,

                  color: colorScheme
                      .onPrimaryContainer,

                  size: 20,
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
                      'Weekly Schedule',
                      style: theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      '${_workingDayCount()} of 7 days selected',

                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: colorScheme
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

          // =====================================================
          // DIVIDER
          // =====================================================

          Divider(
            height: 1,
            color:
            colorScheme
                .outlineVariant,
          ),

          const SizedBox(
            height: 8,
          ),

          // =====================================================
          // QUICK ACTIONS
          // =====================================================

          _buildQuickActions(),

          const SizedBox(
            height: 6,
          ),

          // =====================================================
          // DAYS
          // =====================================================

          ...days.map(
                (day) => _buildDayItem(day),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // QUICK ACTIONS
  // =============================================================

  Widget _buildQuickActions() {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final bool isSmall =
            constraints.maxWidth < 360;

        if (isSmall) {
          return Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              TextButton.icon(
                onPressed:
                _selectMondayToFriday,

                icon: Icon(
                  Icons
                      .business_center_outlined,
                  size: 18,
                  color:
                  colorScheme.primary,
                ),

                label: Text(
                  'Mon - Fri',
                  style: TextStyle(
                    color:
                    colorScheme.primary,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),

              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .end,
                children: [
                  TextButton(
                    onPressed:
                    _selectAllDays,
                    child: Text(
                      'All',
                      style:
                      TextStyle(
                        color:
                        colorScheme
                            .primary,
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed:
                    _clearAllDays,
                    child: Text(
                      'Clear',
                      style:
                      TextStyle(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontWeight:
                        FontWeight
                            .w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            // ===================================================
            // MON - FRI
            // ===================================================

            Expanded(
              child:
              Align(
                alignment:
                Alignment.centerLeft,

                child:
                TextButton.icon(
                  onPressed:
                  _selectMondayToFriday,

                  icon: Icon(
                    Icons
                        .business_center_outlined,
                    size: 18,
                    color:
                    colorScheme
                        .primary,
                  ),

                  label: Text(
                    'Mon - Fri',
                    style:
                    TextStyle(
                      color:
                      colorScheme
                          .primary,
                      fontWeight:
                      FontWeight
                          .w600,
                    ),
                  ),
                ),
              ),
            ),

            // ===================================================
            // ALL
            // ===================================================

            TextButton(
              onPressed:
              _selectAllDays,

              child: Text(
                'All',
                style: TextStyle(
                  color:
                  colorScheme
                      .primary,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),

            // ===================================================
            // CLEAR
            // ===================================================

            TextButton(
              onPressed:
              _clearAllDays,

              child: Text(
                'Clear',
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // DAY ITEM
  // =============================================================

  Widget _buildDayItem(
      _WorkingDay day,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final bool selected =
        day.isWorkingDay;

    return Material(
      color:
      Colors.transparent,

      borderRadius:
      BorderRadius.circular(14),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(
          14,
        ),

        onTap: () {
          setState(() {
            day.isWorkingDay =
            !day.isWorkingDay;
          });
        },

        child: Container(
          width: double.infinity,

          margin:
          const EdgeInsets.symmetric(
            vertical: 4,
          ),

          padding:
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),

          decoration:
          BoxDecoration(
            color: selected
                ? colorScheme
                .primaryContainer
                .withOpacity(.45)
                : colorScheme
                .surfaceContainerHighest
                .withOpacity(.35),

            borderRadius:
            BorderRadius.circular(
              14,
            ),

            border: Border.all(
              color: selected
                  ? colorScheme
                  .primary
                  .withOpacity(.22)
                  : colorScheme
                  .outlineVariant
                  .withOpacity(.70),
            ),
          ),

          child: Row(
            children: [
              // =================================================
              // DAY ICON
              // =================================================

              Container(
                width: 42,
                height: 42,

                alignment:
                Alignment.center,

                decoration:
                BoxDecoration(
                  color: selected
                      ? colorScheme
                      .primaryContainer
                      : colorScheme
                      .surfaceContainerHighest,

                  borderRadius:
                  BorderRadius.circular(
                    11,
                  ),
                ),

                child: Text(
                  day.shortName,

                  style: theme
                      .textTheme
                      .labelMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,

                    color: selected
                        ? colorScheme
                        .onPrimaryContainer
                        : colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              // =================================================
              // DAY NAME
              // =================================================

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [
                    Text(
                      day.name,

                      maxLines: 1,

                      overflow:
                      TextOverflow
                          .ellipsis,

                      style: theme
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      selected
                          ? 'Working day'
                          : 'Day off',

                      maxLines: 1,

                      overflow:
                      TextOverflow
                          .ellipsis,

                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: selected
                            ? colorScheme
                            .primary
                            : colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              // =================================================
              // SWITCH
              // =================================================

              Switch.adaptive(
                value:
                day.isWorkingDay,

                activeColor:
                colorScheme.primary,

                onChanged:
                    (value) {
                  setState(() {
                    day.isWorkingDay =
                        value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  Widget _buildError() {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,

      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
      const EdgeInsets.all(14),

      decoration:
      BoxDecoration(
        color: colorScheme
            .errorContainer
            .withOpacity(.65),

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: colorScheme
              .error
              .withOpacity(.22),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment
            .start,

        children: [
          Icon(
            Icons
                .error_outline_rounded,

            color: colorScheme
                .onErrorContainer,

            size: 21,
          ),

          const SizedBox(
            width: 9,
          ),

          Expanded(
            child: Text(
              errorMessage ?? '',

              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: colorScheme
                    .onErrorContainer,
                height: 1.4,
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // INFORMATION
  // =============================================================

  Widget _buildInformationCard() {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(14),

      decoration:
      BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest
            .withOpacity(.50),

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: colorScheme
              .outlineVariant
              .withOpacity(.60),
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment
            .start,

        children: [
          Icon(
            Icons
                .info_outline_rounded,

            color:
            colorScheme.primary,

            size: 20,
          ),

          const SizedBox(
            width: 9,
          ),

          Expanded(
            child: Text(
              'These working days belong only to the logged-in company. No company selection is required.',

              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                height: 1.4,
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // BOTTOM SAVE BUTTON
  //
  // IMPORTANT:
  // এটি আর Scaffold.bottomNavigationBar নয়।
  //
  // Scaffold body-এর Column-এর নিচে থাকবে।
  // ফলে SnackBar layout conflict হবে না।
  // =============================================================

  Widget _buildBottomSaveButton() {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.fromLTRB(
        14,
        8,
        14,
        12,
      ),

      decoration:
      BoxDecoration(
        color:
        colorScheme.surface,

        border: Border(
          top: BorderSide(
            color:
            colorScheme
                .outlineVariant,
          ),
        ),
      ),

      child: LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final double width =
              constraints.maxWidth;

          final bool isWide =
              width >= 700;

          final double horizontalPadding =
          isWide ? 10 : 0;

          return Center(
            child: ConstrainedBox(
              constraints:
              const BoxConstraints(
                maxWidth: 760,
              ),

              child: Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal:
                  horizontalPadding,
                ),

                child: SizedBox(
                  width: double.infinity,

                  height: 50,

                  child:
                  FilledButton.icon(
                    onPressed:
                    isSaving
                        ? null
                        : _saveWorkingDays,

                    icon: isSaving
                        ? SizedBox(
                      width: 18,
                      height: 18,

                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,

                        color: colorScheme
                            .onPrimary,
                      ),
                    )
                        : const Icon(
                      Icons
                          .save_outlined,
                      size: 20,
                    ),

                    label: Text(
                      isSaving
                          ? 'Saving...'
                          : 'Save Working Days',

                      style: theme
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                        color: colorScheme
                            .onPrimary,

                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    style:
                    FilledButton.styleFrom(
                      minimumSize:
                      const Size(
                        double.infinity,
                        50,
                      ),

                      backgroundColor:
                      colorScheme
                          .primary,

                      foregroundColor:
                      colorScheme
                          .onPrimary,

                      disabledBackgroundColor:
                      colorScheme
                          .surfaceContainerHighest,

                      disabledForegroundColor:
                      colorScheme
                          .onSurfaceVariant,

                      elevation: 0,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =============================================================
  // WORKING DAY COUNT
  // =============================================================

  int _workingDayCount() {
    return days
        .where(
          (day) =>
      day.isWorkingDay,
    )
        .length;
  }

  // =============================================================
  // MONDAY - FRIDAY
  // =============================================================

  void _selectMondayToFriday() {
    setState(() {
      for (final day in days) {
        day.isWorkingDay =
            day.dayNumber <= 5;
      }
    });
  }

  // =============================================================
  // ALL DAYS
  // =============================================================

  void _selectAllDays() {
    setState(() {
      for (final day in days) {
        day.isWorkingDay = true;
      }
    });
  }

  // =============================================================
  // CLEAR ALL
  // =============================================================

  void _clearAllDays() {
    setState(() {
      for (final day in days) {
        day.isWorkingDay = false;
      }
    });
  }
}

// ===============================================================
// WORKING DAY MODEL
// ===============================================================

class _WorkingDay {
  _WorkingDay({
    required this.dayNumber,
    required this.name,
    required this.shortName,
    required this.isWorkingDay,
  });

  final int dayNumber;

  final String name;

  final String shortName;

  bool isWorkingDay;
}