//===============================================================
// Employee Account Menu
//===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_card.dart';

class EmployeeAccountMenu extends StatelessWidget {
  const EmployeeAccountMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // ===========================================================
    // RESPONSIVE
    // ===========================================================

    final screenWidth = MediaQuery.sizeOf(context).width;

    final isSmallScreen = screenWidth < 400;
    final isWideScreen = screenWidth >= 700;

    final horizontalPadding = isSmallScreen
        ? 14.0
        : isWideScreen
        ? 22.0
        : 18.0;

    final iconSize = isSmallScreen
        ? 48.0
        : isWideScreen
        ? 58.0
        : 54.0;

    final iconRadius = isSmallScreen
        ? 12.0
        : 14.0;

    final iconGlyphSize = isSmallScreen
        ? 24.0
        : isWideScreen
        ? 30.0
        : 28.0;

    final arrowSize = isSmallScreen
        ? 34.0
        : 38.0;

    // ===========================================================
    // CARD
    // ===========================================================

    return AppCard(
      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(
            16,
          ),

          // =====================================================
          // NAVIGATION
          // =====================================================

          onTap: () {
            context.push(
              RoutePaths.employeesAccounts,
            );
          },

          child: Padding(
            padding: EdgeInsets.all(
              horizontalPadding,
            ),

            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                // =================================================
                // ICON CONTAINER
                // =================================================

                Container(
                  width: iconSize,
                  height: iconSize,

                  decoration: BoxDecoration(
                    color:
                    colorScheme.primaryContainer,

                    borderRadius:
                    BorderRadius.circular(
                      iconRadius,
                    ),

                    border: Border.all(
                      color: colorScheme.primary
                          .withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),

                  child: Icon(
                    Icons.manage_accounts_rounded,
                    color:
                    colorScheme.onPrimaryContainer,
                    size: iconGlyphSize,
                  ),
                ),

                SizedBox(
                  width: isSmallScreen
                      ? 12
                      : 16,
                ),

                // =================================================
                // CONTENT
                // =================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // ===========================================
                      // TITLE
                      // ===========================================

                      Text(
                        'Employee Accounts',
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        textTheme.titleMedium
                            ?.copyWith(
                          fontWeight:
                          FontWeight.w700,
                          letterSpacing: -0.1,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      // ===========================================
                      // DESCRIPTION
                      // ===========================================

                      Text(
                        'Create, update, activate, deactivate and manage employee login accounts.',
                        maxLines:
                        isSmallScreen
                            ? 3
                            : 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style:
                        textTheme.bodySmall
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: isSmallScreen
                      ? 8
                      : 12,
                ),

                // =================================================
                // ARROW
                // =================================================

                Container(
                  width: arrowSize,
                  height: arrowSize,

                  decoration: BoxDecoration(
                    color: colorScheme
                        .surfaceContainerHighest
                        .withValues(
                      alpha: 0.75,
                    ),
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: colorScheme
                          .outlineVariant
                          .withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ),

                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: isSmallScreen
                        ? 13
                        : 15,
                    color:
                    colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}