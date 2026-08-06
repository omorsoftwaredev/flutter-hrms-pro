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
    return AppCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push(
            RoutePaths.employeesAccounts,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [

              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.manage_accounts,
                  color: Colors.indigo.shade700,
                  size: 30,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Employee Accounts',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Create, update, activate, deactivate and manage employee login accounts.',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),

                  ],
                ),
              ),

              const SizedBox(width: 12),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),

            ],
          ),
        ),
      ),
    );
  }
}