import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() =>
      _UpdatePasswordPageState();
}

class _UpdatePasswordPageState
    extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // =============================================================
  // UPDATE PASSWORD
  // =============================================================

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(
          password: _passwordController.text.trim(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password updated successfully.',
          ),
        ),
      );

      context.go('/login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  // =============================================================
  // PASSWORD FIELD
  // =============================================================

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback onVisibilityToggle,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: !_loading,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
        ),

        suffixIcon: IconButton(
          tooltip: obscureText
              ? 'Show password'
              : 'Hide password',
          onPressed:
          _loading ? null : onVisibilityToggle,
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),

        filled: true,

        fillColor:
        colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.35),

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
      ),

      validator: (value) {
        if (label == 'New Password') {
          if (value == null || value.length < 6) {
            return 'Minimum 6 characters';
          }
        }

        if (label == 'Confirm Password') {
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
        }

        return null;
      },
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final size = MediaQuery.sizeOf(context);

    final bool isDesktop = size.width >= 900;
    final bool isTablet =
        size.width >= 600 && size.width < 900;

    final double horizontalPadding = isDesktop
        ? 40
        : isTablet
        ? 32
        : 20;

    final double cardPadding = isDesktop
        ? 40
        : isTablet
        ? 32
        : 24;

    final double iconSize = isDesktop ? 88 : 76;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        title: const Text(
          'Reset Password',
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics:
            const BouncingScrollPhysics(),

            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isDesktop ? 48 : 24,
            ),

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),

              child: Card(
                elevation: 0,
                color: colorScheme.surface,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(24),

                  side: BorderSide(
                    color:
                    colorScheme.outlineVariant,
                  ),
                ),

                child: Padding(
                  padding:
                  EdgeInsets.all(cardPadding),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                      children: [
                        // =================================================
                        // ICON
                        // =================================================

                        Center(
                          child: Container(
                            width: iconSize,
                            height: iconSize,

                            decoration:
                            BoxDecoration(
                              color: colorScheme
                                  .primary
                                  .withValues(
                                alpha: 0.10,
                              ),
                              shape: BoxShape.circle,
                            ),

                            child: Icon(
                              Icons.lock_reset_rounded,
                              size: isDesktop
                                  ? 44
                                  : 40,
                              color:
                              colorScheme.primary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // =================================================
                        // TITLE
                        // =================================================

                        Text(
                          'Reset Your Password',
                          textAlign:
                          TextAlign.center,

                          style: textTheme
                              .headlineSmall
                              ?.copyWith(
                            fontWeight:
                            FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // =================================================
                        // DESCRIPTION
                        // =================================================

                        Text(
                          'Create a new password to secure your account.',
                          textAlign:
                          TextAlign.center,

                          style: textTheme.bodyMedium
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // =================================================
                        // NEW PASSWORD
                        // =================================================

                        _passwordField(
                          controller:
                          _passwordController,
                          label: 'New Password',
                          hint:
                          'Enter your new password',
                          obscureText:
                          _hidePassword,
                          icon:
                          Icons.lock_outline_rounded,
                          onVisibilityToggle: () {
                            setState(() {
                              _hidePassword =
                              !_hidePassword;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        // =================================================
                        // CONFIRM PASSWORD
                        // =================================================

                        _passwordField(
                          controller:
                          _confirmController,
                          label:
                          'Confirm Password',
                          hint:
                          'Re-enter your new password',
                          obscureText:
                          _hideConfirm,
                          icon:
                          Icons.lock_outline_rounded,
                          onVisibilityToggle: () {
                            setState(() {
                              _hideConfirm =
                              !_hideConfirm;
                            });
                          },
                        ),

                        const SizedBox(height: 14),

                        // =================================================
                        // PASSWORD REQUIREMENT
                        // =================================================

                        Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),

                          decoration:
                          BoxDecoration(
                            color: colorScheme
                                .primary
                                .withValues(
                              alpha: 0.06,
                            ),

                            borderRadius:
                            BorderRadius
                                .circular(12),

                            border: Border.all(
                              color: colorScheme
                                  .primary
                                  .withValues(
                                alpha: 0.12,
                              ),
                            ),
                          ),

                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [
                              Icon(
                                Icons
                                    .info_outline_rounded,
                                size: 18,
                                color: colorScheme
                                    .primary,
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              Expanded(
                                child: Text(
                                  'Password must be at least 6 characters long.',
                                  style: textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // =================================================
                        // UPDATE BUTTON
                        // =================================================

                        SizedBox(
                          height: 54,

                          child:
                          ElevatedButton(
                            onPressed: _loading
                                ? null
                                : _updatePassword,

                            style: ElevatedButton
                                .styleFrom(
                              backgroundColor:
                              colorScheme
                                  .primary,

                              foregroundColor:
                              colorScheme
                                  .onPrimary,

                              disabledBackgroundColor:
                              colorScheme
                                  .primary
                                  .withValues(
                                alpha: 0.45,
                              ),

                              disabledForegroundColor:
                              colorScheme
                                  .onPrimary
                                  .withValues(
                                alpha: 0.80,
                              ),

                              elevation: 0,

                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius
                                    .circular(
                                  14,
                                ),
                              ),
                            ),

                            child: _loading
                                ? SizedBox(
                              width: 23,
                              height: 23,
                              child:
                              CircularProgressIndicator(
                                strokeWidth:
                                2.5,
                                color: colorScheme
                                    .onPrimary,
                              ),
                            )
                                : const Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Icon(
                                  Icons
                                      .lock_reset_rounded,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'UPDATE PASSWORD',
                                  style:
                                  TextStyle(
                                    fontSize:
                                    14,
                                    fontWeight:
                                    FontWeight
                                        .w700,
                                    letterSpacing:
                                    0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // =================================================
                        // SECURITY FOOTER
                        // =================================================

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,

                          children: [
                            Icon(
                              Icons
                                  .verified_outlined,
                              size: 15,
                              color: colorScheme
                                  .onSurfaceVariant,
                            ),

                            const SizedBox(
                              width: 5,
                            ),

                            Text(
                              'Secure HRMS Portal',
                              style: textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}