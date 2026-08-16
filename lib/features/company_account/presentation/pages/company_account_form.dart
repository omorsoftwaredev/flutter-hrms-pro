// ===============================================================
// Flutter HRMS Pro
//
// lib/features/company_account/presentation/pages/company_account_form.dart
//
// Company Account Form
//
// Responsive
// Theme Aware
// Mobile / Tablet / Desktop
//
// Create / Edit
// Professional HRMS UI
// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../company/presentation/providers/company_provider.dart';
import '../../domain/entities/company_account_entity.dart';
import '../providers/company_account_provider.dart';

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
  // =============================================================
  // FORM
  // =============================================================

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  // =============================================================
  // CONTROLLERS
  // =============================================================

  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // =============================================================
  // STATE
  // =============================================================

  String? _selectedCompany;

  bool _isActive = true;

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  bool _isSaving = false;

  // =============================================================
  // GETTERS
  // =============================================================

  bool get isEdit => widget.account != null;

  // =============================================================
  // INIT
  // =============================================================

  @override
  void initState() {
    super.initState();

    _initializeForm();

    Future.microtask(() async {
      await ref
          .read(companyProvider.notifier)
          .loadCompanies();

      if (!mounted) return;

      // ---------------------------------------------------------
      // In case company data loads after widget initialization
      // ---------------------------------------------------------

      if (widget.account != null) {
        setState(() {
          _selectedCompany =
              widget.account!.companyId;

          _usernameController.text =
              widget.account!.username;

          _isActive =
              widget.account!.isActive;
        });
      }
    });
  }

  // =============================================================
  // INITIALIZE FORM
  // =============================================================

  void _initializeForm() {
    final account = widget.account;

    if (account == null) {
      _selectedCompany = null;
      _isActive = true;
      return;
    }

    _selectedCompany = account.companyId;

    _usernameController.text =
        account.username;

    _isActive =
        account.isActive;

    // -----------------------------------------------------------
    // IMPORTANT
    //
    // Never show existing password/hash in the password field.
    // -----------------------------------------------------------

    _passwordController.clear();

    _confirmPasswordController.clear();
  }

  // =============================================================
  // DISPOSE
  // =============================================================

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // =============================================================
  // SAVE
  // =============================================================

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSaving) {
      return;
    }

    final username =
    _usernameController.text.trim();

    final password =
    _passwordController.text.trim();

    final companyId =
        _selectedCompany;

    if (companyId == null ||
        companyId.isEmpty) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // -----------------------------------------------------------
    // Password handling
    //
    // Create:
    //     password is required
    //
    // Edit:
    //     blank = keep existing password
    //     entered = update password
    // -----------------------------------------------------------

    final passwordHash = password.isEmpty
        ? widget.account?.passwordHash ?? ''
        : password;

    final account =
    CompanyAccountEntity(
      id: widget.account?.id,

      companyId: companyId,

      username: username,

      passwordHash: passwordHash,

      isActive: _isActive,

      mustChangePassword:
      widget.account == null
          ? true
          : widget.account!.mustChangePassword,

      lastLoginAt:
      widget.account?.lastLoginAt,

      createdAt:
      widget.account?.createdAt ??
          DateTime.now(),

      updatedAt:
      DateTime.now(),

      createdBy:
      widget.account?.createdBy,

      updatedBy:
      widget.account?.updatedBy,
    );

    try {
      // =========================================================
      // CREATE
      // =========================================================

      if (!isEdit) {
        await ref
            .read(
          companyAccountProvider.notifier,
        )
            .createAccount(account);
      }

      // =========================================================
      // UPDATE
      // =========================================================

      else {
        await ref
            .read(
          companyAccountProvider.notifier,
        )
            .updateAccount(account);
      }

      if (!mounted) return;

      // ---------------------------------------------------------
      // SUCCESS MESSAGE
      // ---------------------------------------------------------

      _showSuccessMessage(
        isEdit
            ? 'Company account updated successfully.'
            : 'Company account created successfully.',
      );

      // ---------------------------------------------------------
      // CLOSE FORM
      // ---------------------------------------------------------

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      if (!mounted) return;

      _showErrorMessage(
        e.toString(),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // =============================================================
  // SUCCESS MESSAGE
  // =============================================================

  void _showSuccessMessage(
      String message,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        behavior:
        SnackBarBehavior.floating,

        backgroundColor:
        colorScheme.primary,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),

        content: Row(
          children: [
            Icon(
              Icons
                  .check_circle_outline_rounded,
              color:
              colorScheme.onPrimary,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                style:
                TextStyle(
                  color:
                  colorScheme.onPrimary,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // ERROR MESSAGE
  // =============================================================

  void _showErrorMessage(
      String message,
      ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        behavior:
        SnackBarBehavior.floating,

        backgroundColor:
        colorScheme.error,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),

        content: Row(
          children: [
            Icon(
              Icons
                  .error_outline_rounded,
              color:
              colorScheme.onError,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow:
                TextOverflow.ellipsis,
                style:
                TextStyle(
                  color:
                  colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // RESPONSIVE MAX WIDTH
  // =============================================================

  double _maxWidth(
      double width,
      ) {
    if (width >= 1400) {
      return 900;
    }

    if (width >= 1000) {
      return 820;
    }

    if (width >= 700) {
      return 720;
    }

    return double.infinity;
  }

  // =============================================================
  // PAGE PADDING
  // =============================================================

  double _horizontalPadding(
      double width,
      ) {
    if (width >= 1200) {
      return 32;
    }

    if (width >= 700) {
      return 24;
    }

    return 16;
  }


  // =============================================================
  // FIELD LABEL
  // =============================================================

  Widget _buildFieldLabel(
      BuildContext context,
      String text, {
        bool required = false,
      }) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 8,
      ),

      child: RichText(
        text:
        TextSpan(
          style: theme
              .textTheme
              .labelLarge
              ?.copyWith(
            fontWeight:
            FontWeight.w700,

            color:
            colorScheme.onSurface,
          ),

          children: [
            TextSpan(
              text: text,
            ),

            if (required)
              TextSpan(
                text: ' *',
                style:
                TextStyle(
                  color:
                  colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final theme =
    Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final companyState =
    ref.watch(companyProvider);

    return LayoutBuilder(
      builder:
          (
          context,
          constraints,
          ) {
        final width =
            constraints.maxWidth;

        final horizontalPadding =
        _horizontalPadding(
          width,
        );

        final maxWidth =
        _maxWidth(width);

        return SingleChildScrollView(
          physics:
          const BouncingScrollPhysics(),

          padding:
          EdgeInsets.fromLTRB(
            horizontalPadding,
            20,
            horizontalPadding,
            36,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints:
              BoxConstraints(
                maxWidth:
                maxWidth,
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,

                  children: [
                    // =================================================
                    // FORM CARD
                    // =================================================

                    Card(
                      margin:
                      EdgeInsets.zero,

                      elevation: 0,

                      color: colorScheme
                          .surfaceContainerLow,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(22),

                        side:
                        BorderSide(
                          color:
                          colorScheme
                              .outlineVariant,
                        ),
                      ),

                      child:
                      Padding(
                        padding:
                        EdgeInsets.all(
                          width >= 700
                              ? 24
                              : 18,
                        ),

                        child:
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch,

                          children: [

                            // =================================================
                            // COMPANY
                            // =================================================

                            _buildFieldLabel(
                              context,
                              'Company',
                              required:
                              true,
                            ),

                            DropdownButtonFormField<
                                String>(
                              initialValue:
                              _selectedCompany,

                              isExpanded:
                              true,

                              decoration:
                              InputDecoration(
                                hintText:
                                'Select company',

                                prefixIcon:
                                const Icon(
                                  Icons
                                      .business_outlined,
                                ),

                                filled:
                                true,

                                fillColor:
                                colorScheme
                                    .surface,

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    14,
                                  ),
                                ),
                              ),

                              items:
                              companyState
                                  .companies
                                  .map(
                                    (
                                    company,
                                    ) {
                                  return DropdownMenuItem<
                                      String>(
                                    value:
                                    company
                                        .id,

                                    child:
                                    Text(
                                      company
                                          .name,

                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                    ),
                                  );
                                },
                              ).toList(),

                              onChanged:
                              _isSaving
                                  ? null
                                  : (
                                  value,
                                  ) {
                                setState(
                                      () {
                                    _selectedCompany =
                                        value;
                                  },
                                );
                              },

                              validator:
                                  (
                                  value,
                                  ) {
                                if (value ==
                                    null ||
                                    value
                                        .isEmpty) {
                                  return 'Please select a company';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // =================================================
                            // USERNAME
                            // =================================================

                            _buildFieldLabel(
                              context,
                              'Username',
                              required:
                              true,
                            ),

                            TextFormField(
                              controller:
                              _usernameController,

                              enabled:
                              !_isSaving,

                              textInputAction:
                              TextInputAction
                                  .next,

                              keyboardType:
                              TextInputType
                                  .text,

                              decoration:
                              InputDecoration(
                                hintText:
                                'Enter username',

                                prefixIcon:
                                const Icon(
                                  Icons
                                      .person_outline_rounded,
                                ),

                                filled:
                                true,

                                fillColor:
                                colorScheme
                                    .surface,

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    14,
                                  ),
                                ),
                              ),

                              validator:
                                  (
                                  value,
                                  ) {
                                if (value ==
                                    null ||
                                    value
                                        .trim()
                                        .isEmpty) {
                                  return 'Username is required';
                                }

                                if (value
                                    .trim()
                                    .length <
                                    3) {
                                  return 'Username must be at least 3 characters';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // =================================================
                            // PASSWORD
                            // =================================================

                            _buildFieldLabel(
                              context,
                              isEdit
                                  ? 'New Password'
                                  : 'Password',
                              required:
                              !isEdit,
                            ),

                            TextFormField(
                              controller:
                              _passwordController,

                              enabled:
                              !_isSaving,

                              obscureText:
                              _obscurePassword,

                              textInputAction:
                              TextInputAction
                                  .next,

                              decoration:
                              InputDecoration(
                                hintText:
                                isEdit
                                    ? 'Leave blank to keep current password'
                                    : 'Enter password',

                                prefixIcon:
                                const Icon(
                                  Icons
                                      .lock_outline_rounded,
                                ),

                                suffixIcon:
                                IconButton(
                                  tooltip:
                                  _obscurePassword
                                      ? 'Show password'
                                      : 'Hide password',

                                  onPressed:
                                  _isSaving
                                      ? null
                                      : () {
                                    setState(
                                          () {
                                        _obscurePassword =
                                        !_obscurePassword;
                                      },
                                    );
                                  },

                                  icon:
                                  Icon(
                                    _obscurePassword
                                        ? Icons
                                        .visibility_off_outlined
                                        : Icons
                                        .visibility_outlined,
                                  ),
                                ),

                                filled:
                                true,

                                fillColor:
                                colorScheme
                                    .surface,

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    14,
                                  ),
                                ),
                              ),

                              validator:
                                  (
                                  value,
                                  ) {
                                final password =
                                    value?.trim() ??
                                        '';

                                // ------------------------------------------------
                                // Create
                                // ------------------------------------------------

                                if (!isEdit &&
                                    password
                                        .isEmpty) {
                                  return 'Password is required';
                                }

                                // ------------------------------------------------
                                // Edit + blank
                                // ------------------------------------------------

                                if (isEdit &&
                                    password
                                        .isEmpty) {
                                  return null;
                                }

                                // ------------------------------------------------
                                // Minimum length
                                // ------------------------------------------------

                                if (password
                                    .length <
                                    6) {
                                  return 'Password must be at least 6 characters';
                                }

                                return null;
                              },
                            ),

                            if (isEdit)
                              Padding(
                                padding:
                                const EdgeInsets.only(
                                  top: 7,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .info_outline_rounded,
                                      size: 15,
                                      color:
                                      colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child:
                                      Text(
                                        'Leave this field blank if you do not want to change the password.',
                                        style: theme
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                          color:
                                          colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(
                              height: 20,
                            ),

                            // =================================================
                            // CONFIRM PASSWORD
                            // =================================================

                            _buildFieldLabel(
                              context,
                              'Confirm Password',
                              required:
                              !isEdit,
                            ),

                            TextFormField(
                              controller:
                              _confirmPasswordController,

                              enabled:
                              !_isSaving,

                              obscureText:
                              _obscureConfirmPassword,

                              textInputAction:
                              TextInputAction
                                  .done,

                              onFieldSubmitted:
                                  (_) {
                                if (!_isSaving) {
                                  _save();
                                }
                              },

                              decoration:
                              InputDecoration(
                                hintText:
                                isEdit
                                    ? 'Confirm new password'
                                    : 'Re-enter password',

                                prefixIcon:
                                const Icon(
                                  Icons
                                      .lock_reset_outlined,
                                ),

                                suffixIcon:
                                IconButton(
                                  tooltip:
                                  _obscureConfirmPassword
                                      ? 'Show password'
                                      : 'Hide password',

                                  onPressed:
                                  _isSaving
                                      ? null
                                      : () {
                                    setState(
                                          () {
                                        _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                      },
                                    );
                                  },

                                  icon:
                                  Icon(
                                    _obscureConfirmPassword
                                        ? Icons
                                        .visibility_off_outlined
                                        : Icons
                                        .visibility_outlined,
                                  ),
                                ),

                                filled:
                                true,

                                fillColor:
                                colorScheme
                                    .surface,

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    14,
                                  ),
                                ),
                              ),

                              validator:
                                  (
                                  value,
                                  ) {
                                final confirm =
                                    value?.trim() ??
                                        '';

                                final password =
                                _passwordController
                                    .text
                                    .trim();

                                // ------------------------------------------------
                                // Create
                                // ------------------------------------------------

                                if (!isEdit &&
                                    confirm
                                        .isEmpty) {
                                  return 'Please confirm the password';
                                }

                                // ------------------------------------------------
                                // Edit + both empty
                                // ------------------------------------------------

                                if (isEdit &&
                                    password
                                        .isEmpty &&
                                    confirm
                                        .isEmpty) {
                                  return null;
                                }

                                // ------------------------------------------------
                                // One field entered
                                // ------------------------------------------------

                                if (password
                                    .isEmpty !=
                                    confirm
                                        .isEmpty) {
                                  return 'Please enter and confirm the new password';
                                }

                                // ------------------------------------------------
                                // Mismatch
                                // ------------------------------------------------

                                if (password !=
                                    confirm) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(
                              height: 24,
                            ),

                            // =================================================
                            // ACCESS SETTINGS
                            // =================================================

                            Container(
                              width:
                              double.infinity,

                              padding:
                              const EdgeInsets
                                  .all(16),

                              decoration:
                              BoxDecoration(
                                color:
                                colorScheme
                                    .surface,

                                borderRadius:
                                BorderRadius
                                    .circular(
                                  16,
                                ),

                                border:
                                Border.all(
                                  color:
                                  colorScheme
                                      .outlineVariant,
                                ),
                              ),

                              child:
                              Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,

                                    decoration:
                                    BoxDecoration(
                                      color:
                                      _isActive
                                          ? colorScheme
                                          .secondaryContainer
                                          : colorScheme
                                          .errorContainer,

                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                        12,
                                      ),
                                    ),

                                    child:
                                    Icon(
                                      _isActive
                                          ? Icons
                                          .check_circle_outline_rounded
                                          : Icons
                                          .block_outlined,

                                      color:
                                      _isActive
                                          ? colorScheme
                                          .onSecondaryContainer
                                          : colorScheme
                                          .onErrorContainer,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child:
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                      children: [
                                        Text(
                                          'Active Account',

                                          style: theme
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                            fontWeight:
                                            FontWeight
                                                .w700,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 3,
                                        ),

                                        Text(
                                          _isActive
                                              ? 'This account can access the system.'
                                              : 'This account is currently disabled.',

                                          style: theme
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                            color:
                                            colorScheme
                                                .onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 8,
                                  ),

                                  Switch.adaptive(
                                    value:
                                    _isActive,

                                    onChanged:
                                    _isSaving
                                        ? null
                                        : (
                                        value,
                                        ) {
                                      setState(
                                            () {
                                          _isActive =
                                              value;
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 28,
                            ),

                            // =================================================
                            // SAVE BUTTON
                            // =================================================

                            SizedBox(
                              height: 54,

                              child:
                              FilledButton
                                  .icon(
                                onPressed:
                                _isSaving
                                    ? null
                                    : _save,

                                icon:
                                _isSaving
                                    ? SizedBox(
                                  width: 19,
                                  height: 19,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth:
                                    2.2,

                                    color:
                                    colorScheme
                                        .onPrimary,
                                  ),
                                )
                                    : Icon(
                                  isEdit
                                      ? Icons
                                      .save_outlined
                                      : Icons
                                      .add_circle_outline_rounded,
                                ),

                                label:
                                Text(
                                  _isSaving
                                      ? 'Saving...'
                                      : isEdit
                                      ? 'Update Account'
                                      : 'Create Account',

                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}