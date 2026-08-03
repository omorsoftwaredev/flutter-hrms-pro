//===============================================================
// lib/features/company_account/presentation/pages/company_account_form.dart
//===============================================================
import '../../../company/presentation/providers/company_provider.dart';
import '../providers/company_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/company_account_entity.dart';
class CompanyAccountForm extends ConsumerStatefulWidget {
  final CompanyAccountEntity? account;

  const CompanyAccountForm({
    super.key,
    this.account,
  });

  @override
  ConsumerState<CompanyAccountForm> createState() =>
      _CompanyAccountFormState();
}

class _CompanyAccountFormState
    extends ConsumerState<CompanyAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _usernameController =
  TextEditingController();


  String? _selectedCompany;

  bool _isActive = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final account = CompanyAccountEntity(
      id: widget.account?.id,
      companyId: _selectedCompany!,
      username: _usernameController.text.trim(),

      // Edit mode এ password না বদলালে আগেরটা থাকবে
      passwordHash: _passwordController.text.trim().isEmpty
          ? widget.account?.passwordHash ?? ''
          : _passwordController.text.trim(),

      isActive: _isActive,
      mustChangePassword: widget.account == null,

      lastLoginAt: widget.account?.lastLoginAt,

      createdAt: widget.account?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),

      createdBy: widget.account?.createdBy,
      updatedBy: widget.account?.updatedBy,
    );

    try {
      if (widget.account == null) {
        await ref
            .read(companyAccountProvider.notifier)
            .createAccount(account);
      } else {
        await ref
            .read(companyAccountProvider.notifier)
            .updateAccount(account);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.account == null
                ? 'Company Account Created Successfully'
                : 'Company Account Updated Successfully',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.account);
    print(widget.account?.id);
    print(widget.account?.companyId);
    print(widget.account?.username);
    Future.microtask(() async {
      await ref.read(companyProvider.notifier).loadCompanies();

      if (!mounted) return;

      if (widget.account != null) {
        setState(() {
          _selectedCompany = widget.account!.companyId;
          _usernameController.text = widget.account!.username;
          _isActive = widget.account!.isActive;

          _passwordController.text =
              widget.account!.passwordHash ?? '';

          _confirmPasswordController.text =
              widget.account!.passwordHash ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final companyState = ref.watch(companyProvider);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Company
          DropdownButtonFormField<String>(
            value: _selectedCompany,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Company',
              border: OutlineInputBorder(),
            ),
            items: companyState.companies
                .map(
                  (company) => DropdownMenuItem<String>(
                value: company.id,
                child: Text(company.name),
              ),
            )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCompany = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Select company';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
            validator: (value) {
              if (widget.account == null) {
                if (value == null || value.isEmpty) {
                  return 'Password required';
                }

                if (value.length < 6) {
                  return 'Minimum 6 characters';
                }
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword =
                    !_obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              ),
            ),
            validator: (value) {
              if (widget.account == null) {
                if (value != _passwordController.text) {
                  return 'Password does not match';
                }
              }

              return null;
            },
          ),


          const SizedBox(height: 20),

          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: _isActive,
            title: const Text('Active Account'),
            subtitle: const Text(
              'Enable or disable this account',
            ),
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
          ),

          const SizedBox(height: 30),

          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text(
                'Save Account',
              ),
            ),
          ),
        ],
      ),
    );
  }
}