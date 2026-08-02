/// ===============================================================
/// Flutter HRMS Pro
/// Company Details Page
///
/// Version : 1.0.0
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/company_provider.dart';

class CompanyDetailsPage extends ConsumerWidget {
  final String companyId;

  const CompanyDetailsPage({
    super.key,
    required this.companyId,
  });

  Widget _item(
      String title,
      String? value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value == null || value.isEmpty
                ? "-"
                : value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final company =
    ref.watch(companyProvider(companyId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Company Details",
        ),
      ),

      body: company.when(
        loading: () => const Center(
          child:
          CircularProgressIndicator(),
        ),

        error: (e, s) => Center(
          child: Text(
            e.toString(),
          ),
        ),

        data: (company) {
          if (company == null) {
            return const Center(
              child: Text(
                "Company Not Found",
              ),
            );
          }

          return ListView(
            padding:
            const EdgeInsets.all(20),
            children: [

              Center(
                child: CircleAvatar(
                  radius: 45,
                  child: Text(
                    company.name
                        .substring(0, 1)
                        .toUpperCase(),
                    style:
                    const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              _item(
                "Company Code",
                company.code,
              ),

              _item(
                "Company Name",
                company.name,
              ),

              _item(
                "Phone",
                company.phone,
              ),

              _item(
                "Email",
                company.email,
              ),

              _item(
                "Website",
                company.website,
              ),

              _item(
                "Address",
                company.address,
              ),

              _item(
                "Contact Person",
                company.contactPerson,
              ),

              _item(
                "Status",
                company.isActive
                    ? "Active"
                    : "Inactive",
              ),

              _item(
                "Created At",
                company.createdAt
                    ?.toString(),
              ),

              _item(
                "Updated At",
                company.updatedAt
                    ?.toString(),
              ),
            ],
          );
        },
      ),
    );
  }
}