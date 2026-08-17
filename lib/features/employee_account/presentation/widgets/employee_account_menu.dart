//===============================================================
// Employee Account Menu
//===============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_card.dart';

class EmployeeAccountMenu extends StatelessWidget {
  const EmployeeAccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final screenWidth = MediaQuery.sizeOf(context).width;

    final isSmallScreen = screenWidth < 400;
    final isWideScreen = screenWidth >= 700;

    return AppCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),

          onTap: () {
            context.push(RoutePaths.employeesAccounts);
          },

          child: Padding(
            padding: EdgeInsets.all(
              isSmallScreen
                  ? 14
                  : isWideScreen
                  ? 22
                  : 18,
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //=================================================
                // ICON
                //=================================================
                Container(
                  width: isSmallScreen ? 48 : 56,
                  height: isSmallScreen ? 48 : 56,

                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(
                      isSmallScreen ? 12 : 14,
                    ),
                  ),

                  child: Icon(
                    Icons.manage_accounts_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: isSmallScreen ? 25 : 30,
                  ),
                ),

                SizedBox(width: isSmallScreen ? 12 : 16),

                //=================================================
                // CONTENT
                //=================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Employee Accounts',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Create, update, activate, deactivate and manage employee login accounts.',
                        maxLines: isSmallScreen ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: isSmallScreen ? 8 : 12),

                //=================================================
                // ARROW
                //=================================================
                Container(
                  width: isSmallScreen ? 32 : 36,
                  height: isSmallScreen ? 32 : 36,

                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: isSmallScreen ? 14 : 16,
                    color: colorScheme.onSurfaceVariant,
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
