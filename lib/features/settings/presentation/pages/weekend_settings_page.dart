/// ===============================================================
/// Flutter HRMS Pro
///
/// Weekend Settings Page
///
/// Version : 1.0.0
///
/// Features:
/// - Company-wise weekend settings
/// - Logged-in company automatically detected
/// - No company dropdown
/// - Saturday / Sunday configuration
/// - Responsive UI
/// - Dark / Light theme compatible
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/auth/current_user.dart';
import '../../../../core/auth/current_user_provider.dart';
import '../../../../core/services/supabase_service.dart';

class WeekendSettingsPage extends ConsumerStatefulWidget {
  const WeekendSettingsPage({
    super.key,
  });

  @override
  ConsumerState<WeekendSettingsPage> createState() =>
      _WeekendSettingsPageState();
}

class _WeekendSettingsPageState
    extends ConsumerState<WeekendSettingsPage> {
  // =============================================================
  // CONSTANT
  // =============================================================

  static const Color primaryColor =
  Color(0xFF2196F3);

  // =============================================================
  // STATE
  // =============================================================

  bool isLoading = true;
  bool isSaving = false;

  bool saturday = false;
  bool sunday = true;

  String? errorMessage;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeekendSettings();
    });
  }

  // =============================================================
  // LOAD
  // =============================================================

  Future<void> _loadWeekendSettings() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

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

      final response =
      await SupabaseService.client
          .from('company_weekend_settings')
          .select(
        'saturday, sunday',
      )
          .eq(
        'company_id',
        companyId,
      )
          .maybeSingle();

      if (response != null) {
        saturday =
            response['saturday'] == true;

        sunday =
            response['sunday'] == true;
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

  Future<void> _saveWeekendSettings() async {
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

      await SupabaseService.client
          .from('company_weekend_settings')
          .upsert(
        {
          'company_id': companyId,
          'saturday': saturday,
          'sunday': sunday,
          'updated_at':
          DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'company_id',
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
            'Weekend settings saved successfully.',
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
            'Failed to save weekend settings.\n$e',
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

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        Theme.of(context).scaffoldBackgroundColor,
        foregroundColor:
        Theme.of(context)
            .colorScheme
            .onSurface,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Weekend',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : _buildBody(),
      ),

      // =========================================================
      // SAVE BUTTON
      // =========================================================

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
              onPressed: isSaving
                  ? null
                  : _saveWeekendSettings,

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
                    : 'Save Weekend',
              ),

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                primaryColor,
                foregroundColor:
                Colors.white,
                elevation: 0,
                shape:
                RoundedRectangleBorder(
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

                  _buildWeekendCard(),

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
        Theme.of(context)
            .colorScheme
            .primary;

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
              Icons.weekend_outlined,
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
                  'Weekend Settings',
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
                  'Configure which days are treated as weekly weekends for your company.',
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
  // WEEKEND CARD
  // =============================================================

  Widget _buildWeekendCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
        Theme.of(context).cardColor,

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
                Icons.calendar_today_outlined,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  'Weekly Weekend',
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

          _buildDayOption(
            title: 'Saturday',
            subtitle:
            'Treat Saturday as a weekly weekend.',
            icon: Icons.weekend_outlined,
            value: saturday,
            onChanged: (value) {
              setState(() {
                saturday = value;
              });
            },
          ),

          _buildDayOption(
            title: 'Sunday',
            subtitle:
            'Treat Sunday as a weekly weekend.',
            icon: Icons.weekend_outlined,
            value: sunday,
            onChanged: (value) {
              setState(() {
                sunday = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // =============================================================
  // DAY OPTION
  // =============================================================

  Widget _buildDayOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final primary =
        Theme.of(context)
            .colorScheme
            .primary;

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: value
            ? primary.withOpacity(.06)
            : Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(.35),

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color: value
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

            decoration: BoxDecoration(
              color: value
                  ? primary.withOpacity(.10)
                  : Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,

              borderRadius:
              BorderRadius.circular(11),
            ),

            child: Icon(
              icon,
              size: 21,
              color: value
                  ? primary
                  : Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(.55),
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
                  title,
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
                  value
                      ? 'Weekend'
                      : 'Regular day',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: value
                        ? primary
                        : Theme.of(
                      context,
                    )
                        .colorScheme
                        .onSurface
                        .withOpacity(
                      .55,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    fontSize: 10,
                    color: Theme.of(
                      context,
                    )
                        .colorScheme
                        .onSurface
                        .withOpacity(.50),
                  ),
                ),
              ],
            ),
          ),

          Switch.adaptive(
            value: value,
            activeColor: primary,
            onChanged: onChanged,
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

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.07),

        borderRadius:
        BorderRadius.circular(12),

        border: Border.all(
          color:
          Colors.red.withOpacity(.20),
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
        Theme.of(context)
            .colorScheme
            .primary;

    return Container(
      width: double.infinity,

      padding:
      const EdgeInsets.all(14),

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
              'Weekend settings are stored separately for each company and automatically use the logged-in user’s company.',
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