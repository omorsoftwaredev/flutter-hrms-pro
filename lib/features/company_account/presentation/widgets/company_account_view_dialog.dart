// ===============================================================
// Company Account View Dialog
// ===============================================================

import 'package:flutter/material.dart';

import '../../domain/entities/company_account_entity.dart';

Future<void> showCompanyAccountDialog(
    BuildContext context,
    CompanyAccountEntity account,
    ) {
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text(
          'Company Account',
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _item(
                "Company ID",
                account.companyId,
              ),

              _item(
                "Username",
                account.username,
              ),

              _item(
                "Status",
                account.isActive
                    ? "Active"
                    : "Inactive",
              ),

              _item(
                "Must Change Password",
                account.mustChangePassword
                    ? "Yes"
                    : "No",
              ),

              _item(
                "Last Login",
                account.lastLoginAt == null
                    ? "-"
                    : account.lastLoginAt.toString(),
              ),

              _item(
                "Created At",
                account.createdAt.toString(),
              ),

              _item(
                "Updated At",
                account.updatedAt == null
                    ? "-"
                    : account.updatedAt.toString(),
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "OK",
            ),
          ),
        ],
      );
    },
  );
}

Widget _item(
    String title,
    String value,
    ) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 12,
    ),
    child: Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(value),
      ],
    ),
  );
}