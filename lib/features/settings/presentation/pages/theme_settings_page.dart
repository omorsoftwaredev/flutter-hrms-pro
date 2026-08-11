/// ===============================================================
/// Flutter HRMS Pro
///
/// Appearance Settings Page
///
/// Version : 1.0.1
///
/// Features:
/// - Light Theme
/// - Dark Theme
/// - System Theme
/// - Responsive UI
/// - Instant Theme Change
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_provider.dart';

class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    // ===========================================================
    // CURRENT THEME MODE
    // ===========================================================

    final ThemeMode themeMode = ref.watch(
      themeModeProvider,
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===========================================================
    // SCAFFOLD
    // ===========================================================

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Theme Settings ',
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
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final bool isWide =
                constraints.maxWidth >= 700;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWide
                      ? 760
                      : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide
                        ? 24
                        : 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // HEADER
                      // =================================================

                      _buildHeader(
                        context,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // =================================================
                      // THEME CARD
                      // =================================================

                      _buildThemeCard(
                        context,
                        ref,
                        themeMode,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // =================================================
                      // INFORMATION
                      // =================================================

                      _buildInformationCard(
                        context,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(
          0.08,
        ),
        borderRadius: BorderRadius.circular(
          18,
        ),
      ),
      child: Row(
        children: [
          // =====================================================
          // ICON
          // =====================================================

          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(
                0.12,
              ),
              borderRadius:
              BorderRadius.circular(
                16,
              ),
            ),
            child: Icon(
              Icons.palette_outlined,
              size: 30,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(
            width: 15,
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
                  'Appearance',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  'Customize how HRMS Pro looks on your device.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface
                        .withOpacity(
                      0.65,
                    ),
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
  // THEME CARD
  // =============================================================

  Widget _buildThemeCard(
      BuildContext context,
      WidgetRef ref,
      ThemeMode themeMode,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: theme.dividerColor.withOpacity(
            0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // =====================================================
          // TITLE
          // =====================================================

          Row(
            children: [
              Icon(
                Icons.brightness_6_outlined,
                color: colorScheme.primary,
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
                      'Theme',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      _themeDescription(
                        themeMode,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface
                            .withOpacity(
                          0.60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          const Divider(
            height: 1,
          ),

          const SizedBox(
            height: 8,
          ),

          // =====================================================
          // LIGHT
          // =====================================================

          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: themeMode,
            title: 'Light',
            subtitle:
            'Always use the light theme.',
            icon: Icons.light_mode_outlined,
            value: ThemeMode.light,
          ),

          // =====================================================
          // DARK
          // =====================================================

          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: themeMode,
            title: 'Dark',
            subtitle:
            'Always use the dark theme.',
            icon: Icons.dark_mode_outlined,
            value: ThemeMode.dark,
          ),

          // =====================================================
          // SYSTEM
          // =====================================================

          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: themeMode,
            title: 'System',
            subtitle:
            'Follow your device theme.',
            icon: Icons.settings_suggest_outlined,
            value: ThemeMode.system,
          ),
        ],
      ),
    );
  }

  // =============================================================
  // THEME OPTION
  // =============================================================

  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required ThemeMode themeMode,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode value,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ===========================================================
    // SELECTED
    // ===========================================================

    final bool selected =
        themeMode == value;

    final Color primary =
        colorScheme.primary;

    return InkWell(
      borderRadius:
      BorderRadius.circular(14),

      // =========================================================
      // CLICK
      // =========================================================

      onTap: () {
        ref
            .read(
          themeModeProvider.notifier,
        )
            .setTheme(value);
      },

      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.only(
          top: 4,
          bottom: 4,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color: selected
              ? primary.withOpacity(
            0.07,
          )
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(14),

          border: Border.all(
            color: selected
                ? primary.withOpacity(
              0.35,
            )
                : Colors.transparent,
          ),
        ),

        child: Row(
          children: [
            // =================================================
            // ICON
            // =================================================

            Container(
              width: 42,
              height: 42,

              decoration: BoxDecoration(
                color: selected
                    ? primary.withOpacity(
                  0.12,
                )
                    : colorScheme
                    .surfaceContainerHighest,

                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: Icon(
                icon,
                size: 22,
                color: selected
                    ? primary
                    : colorScheme
                    .onSurface
                    .withOpacity(
                  0.65,
                ),
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            // =================================================
            // TEXT
            // =================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme
                          .onSurface
                          .withOpacity(
                        0.60,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            // =================================================
            // RADIO
            // =================================================

            Radio<ThemeMode>(
              value: value,

              groupValue: themeMode,

              onChanged: (newValue) {
                if (newValue == null) {
                  return;
                }

                ref
                    .read(
                  themeModeProvider.notifier,
                )
                    .setTheme(newValue);
              },

              activeColor: primary,

              materialTapTargetSize:
              MaterialTapTargetSize
                  .shrinkWrap,

              visualDensity:
              const VisualDensity(
                horizontal: -2,
                vertical: -2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // INFORMATION CARD
  // =============================================================

  Widget _buildInformationCard(
      BuildContext context,
      ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: colorScheme
            .surfaceContainerHighest
            .withOpacity(
          0.45,
        ),

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // =====================================================
          // INFO ICON
          // =====================================================

          Icon(
            Icons.info_outline,
            size: 21,
            color: colorScheme.primary,
          ),

          const SizedBox(
            width: 10,
          ),

          // =====================================================
          // INFO TEXT
          // =====================================================

          Expanded(
            child: Text(
              'Theme changes are applied immediately across HRMS Pro.',
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // THEME DESCRIPTION
  // =============================================================

  String _themeDescription(
      ThemeMode mode,
      ) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light theme is currently selected.';

      case ThemeMode.dark:
        return 'Dark theme is currently selected.';

      case ThemeMode.system:
        return 'Following your device theme.';
    }
  }
}