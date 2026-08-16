/// ===============================================================
/// Flutter HRMS Pro
///
/// Appearance Settings Page
///
/// Version : 2.0.0
///
/// Features:
/// - Fully Theme Aware
/// - Light / Dark / System
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
    final ThemeMode themeMode =
    ref.watch(themeModeProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,

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
          'Theme Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              context,
              constraints,
              ) {
            final width = constraints.maxWidth;
            final isWide = width >= 700;

            final horizontalPadding =
            width >= 1000
                ? 32.0
                : isWide
                ? 24.0
                : 16.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 760,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    32,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),

                      const SizedBox(height: 20),

                      _buildThemeCard(
                        context,
                        ref,
                        themeMode,
                      ),

                      const SizedBox(height: 20),

                      _buildInformationCard(context),
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
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
        colors.primaryContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
          colors.outlineVariant.withOpacity(0.65),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
              colors.primary.withOpacity(0.12),
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.palette_outlined,
              size: 30,
              color: colors.primary,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style:
                  theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Customize how HRMS Pro looks on your device.',
                  style:
                  theme.textTheme.bodyMedium?.copyWith(
                    color:
                    colors.onSurfaceVariant,
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
  // THEME CARD
  // =============================================================

  Widget _buildThemeCard(
      BuildContext context,
      WidgetRef ref,
      ThemeMode themeMode,
      ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.brightness_6_outlined,
                color: colors.primary,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style:
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      _themeDescription(themeMode),
                      style:
                      theme.textTheme.bodySmall?.copyWith(
                        color:
                        colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Divider(
            height: 1,
            color: colors.outlineVariant,
          ),

          const SizedBox(height: 8),

          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: themeMode,
            title: 'Light',
            subtitle:
            'Always use the light theme.',
            icon:
            Icons.light_mode_outlined,
            value: ThemeMode.light,
          ),

          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: themeMode,
            title: 'Dark',
            subtitle:
            'Always use the dark theme.',
            icon:
            Icons.dark_mode_outlined,
            value: ThemeMode.dark,
          ),

          _buildThemeOption(
            context: context,
            ref: ref,
            themeMode: themeMode,
            title: 'System',
            subtitle:
            'Follow your device theme.',
            icon:
            Icons.settings_suggest_outlined,
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
    final colors = theme.colorScheme;

    final selected = themeMode == value;

    return InkWell(
      borderRadius:
      BorderRadius.circular(14),
      onTap: () {
        ref
            .read(themeModeProvider.notifier)
            .setTheme(value);
      },
      child: Container(
        width: double.infinity,
        margin:
        const EdgeInsets.symmetric(vertical: 4),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary
              .withOpacity(0.07)
              : colors.surface,
          borderRadius:
          BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? colors.primary
                .withOpacity(0.35)
                : colors.outlineVariant
                .withOpacity(0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? colors.primary
                    .withOpacity(0.12)
                    : colors
                    .surfaceContainerHighest,
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected
                    ? colors.primary
                    : colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                    theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                      FontWeight.w600,
                      color:
                      colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style:
                    theme.textTheme.bodySmall?.copyWith(
                      color:
                      colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Radio<ThemeMode>(
              value: value,
              groupValue: themeMode,
              onChanged: (newValue) {
                if (newValue != null) {
                  ref
                      .read(
                    themeModeProvider.notifier,
                  )
                      .setTheme(newValue);
                }
              },
              activeColor: colors.primary,
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
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors
            .surfaceContainerHighest
            .withOpacity(0.45),
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color:
          colors.outlineVariant.withOpacity(0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 21,
            color: colors.primary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Theme changes are applied immediately across HRMS Pro.',
              style:
              theme.textTheme.bodySmall?.copyWith(
                color:
                colors.onSurfaceVariant,
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