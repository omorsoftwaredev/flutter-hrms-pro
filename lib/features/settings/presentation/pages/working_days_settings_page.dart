/// ===============================================================
/// Flutter HRMS Pro
///
/// Working Days Settings Page
///
/// Version : 1.0.0
///
/// Features:
/// - Company-wise working days
/// - No company dropdown
/// - Uses logged-in user's company
/// - Responsive UI
/// - Save working-day configuration
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
  static const Color primaryColor = Color(0xFF2196F3);

  bool isLoading = true;
  bool isSaving = false;

  String? errorMessage;

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWorkingDays();
    });
  }

  // =============================================================
  // LOAD
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
      final CurrentUser? user = ref.read(currentUserProvider);

      if (user == null) {
        throw Exception(
          'Logged-in user information was not found.',
        );
      }

      final companyId = user.companyId;

      if (companyId == null ||
          companyId.trim().isEmpty) {
        throw Exception(
          'Company ID was not found for the logged-in user.',
        );
      }

      final response = await SupabaseService.client
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

      final rows = List<Map<String, dynamic>>.from(
        response,
      );

      if (rows.isNotEmpty) {
        for (final day in days) {
          final row = rows.cast<Map<String, dynamic>?>().firstWhere(
                (item) =>
            item?['day_of_week'] == day.dayNumber,
            orElse: () => null,
          );

          if (row != null) {
            day.isWorkingDay =
                row['is_working_day'] == true;
          }
        }
      }

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
  // SAVE
  // =============================================================

  Future<void> _saveWorkingDays() async {
    if (isSaving) {
      return;
    }

    try {
      final CurrentUser? user =
      ref.read(currentUserProvider);

      if (user == null) {
        throw Exception(
          'Logged-in user information was not found.',
        );
      }

      final companyId = user.companyId;

      if (companyId == null ||
          companyId.trim().isEmpty) {
        throw Exception(
          'Company ID was not found for the logged-in user.',
        );
      }

      setState(() {
        isSaving = true;
        errorMessage = null;
      });

      final payload = days.map((day) {
        return {
          'company_id': companyId,
          'day_of_week': day.dayNumber,
          'is_working_day': day.isWorkingDay,
        };
      }).toList();

      await SupabaseService.client
          .from('company_working_days')
          .upsert(
        payload,
        onConflict:
        'company_id,day_of_week',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Working days saved successfully.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
        errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save working days.\n$e',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        Theme.of(context).scaffoldBackgroundColor,
        foregroundColor:
        Theme.of(context).colorScheme.onSurface,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Working Days',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : _buildBody(),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16,
          ),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
              isSaving ? null : _saveWorkingDays,
              icon: isSaving
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
                isSaving
                    ? 'Saving...'
                    : 'Save Working Days',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
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
        final isWide =
            constraints.maxWidth >= 700;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 24 : 14,
            vertical: 16,
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
                  _buildHeader(),

                  const SizedBox(
                    height: 16,
                  ),

                  if (errorMessage != null)
                    _buildError(),

                  _buildWorkingDaysCard(),

                  const SizedBox(
                    height: 16,
                  ),

                  _buildInformationCard(),
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
    final primary =
        Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary.withOpacity(.08),
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color:
              primary.withOpacity(.12),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: primary,
              size: 27,
            ),
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Working Days',
                  style: Theme.of(context)
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
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.65),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context)
              .dividerColor
              .withOpacity(.5),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.work_outline,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  'Weekly Schedule',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          const Divider(
            height: 1,
          ),

          const SizedBox(
            height: 8,
          ),

          ...days.map(
                (day) => _buildDayItem(day),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DAY ITEM
  // =============================================================

  Widget _buildDayItem(
      _WorkingDay day,
      ) {
    final primary =
        Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: day.isWorkingDay
            ? primary.withOpacity(.06)
            : Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(.35),
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: day.isWorkingDay
              ? primary.withOpacity(.20)
              : Theme.of(context)
              .dividerColor
              .withOpacity(.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: day.isWorkingDay
                  ? primary.withOpacity(.10)
                  : Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius:
              BorderRadius.circular(11),
            ),
            child: Text(
              day.shortName,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                FontWeight.w700,
                color: day.isWorkingDay
                    ? primary
                    : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(.60),
              ),
            ),
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
                  day.name,
                  style: Theme.of(context)
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
                  day.isWorkingDay
                      ? 'Working day'
                      : 'Day off',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: day.isWorkingDay
                        ? primary
                        : Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.55),
                  ),
                ),
              ],
            ),
          ),

          Switch.adaptive(
            value: day.isWorkingDay,
            activeColor: primary,
            onChanged: (value) {
              setState(() {
                day.isWorkingDay = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ERROR
  // =============================================================

  Widget _buildError() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.07),
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(.20),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(
            width: 9,
          ),
          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
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
    final primary =
        Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(.40),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: primary,
            size: 20,
          ),
          const SizedBox(
            width: 9,
          ),
          Expanded(
            child: Text(
              'These working days belong only to the logged-in company. No company selection is required.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// MODEL
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