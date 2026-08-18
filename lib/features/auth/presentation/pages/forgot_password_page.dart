import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/supabase_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // =============================================================
  // RESET PASSWORD
  // =============================================================

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      await SupabaseService.client.auth.resetPasswordForEmail(
        _emailController.text.trim(),
        redirectTo: 'hrmspro://reset-password',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset link has been sent to your email.',
          ),
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
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
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        title: const Text(
          'Forgot Password',
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // ---------------------------------------------------
            // RESPONSIVE CONTENT WIDTH
            // ---------------------------------------------------

            double contentWidth;

            if (width < 600) {
              // Mobile
              contentWidth = width;
            } else if (width < 1000) {
              // Tablet
              contentWidth = 520;
            } else {
              // Desktop
              contentWidth = 560;
            }

            // ---------------------------------------------------
            // RESPONSIVE PADDING
            // ---------------------------------------------------

            final horizontalPadding = width < 600
                ? 20.0
                : width < 1000
                ? 32.0
                : 40.0;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: width < 600 ? 20 : 32,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: contentWidth,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                      children: [
                        // =========================================
                        // HEADER ICON
                        // =========================================

                        Center(
                          child: Container(
                            width: width < 600 ? 78 : 88,
                            height: width < 600 ? 78 : 88,
                            decoration: BoxDecoration(
                              color: colorScheme.primary
                                  .withOpacity(.10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_reset_outlined,
                              size: width < 600 ? 40 : 46,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: width < 600 ? 22 : 28,
                        ),

                        // =========================================
                        // TITLE
                        // =========================================

                        Text(
                          'Forgot your password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: width < 600 ? 23 : 27,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // =========================================
                        // DESCRIPTION
                        // =========================================

                        Text(
                          'Enter your registered email address to '
                              'receive a password reset link.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colorScheme.onSurface
                                .withOpacity(.60),
                            fontSize: width < 600 ? 13 : 14,
                            height: 1.5,
                          ),
                        ),

                        SizedBox(
                          height: width < 600 ? 28 : 36,
                        ),

                        // =========================================
                        // FORM CARD
                        // =========================================

                        Card(
                          elevation:
                          theme.brightness == Brightness.dark
                              ? 0
                              : 2,
                          shadowColor:
                          colorScheme.shadow.withOpacity(.12),
                          color: colorScheme.surfaceContainerHighest
                              .withOpacity(
                            theme.brightness == Brightness.dark
                                ? .35
                                : .45,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20),
                            side: BorderSide(
                              color: colorScheme.outline
                                  .withOpacity(.10),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              width < 600 ? 18 : 24,
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                // =================================
                                // EMAIL
                                // =================================

                                TextFormField(
                                  controller:
                                  _emailController,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  textInputAction:
                                  TextInputAction.done,
                                  onFieldSubmitted: (_) {
                                    if (!_loading) {
                                      _resetPassword();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText:
                                    'Enter your registered email',
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color:
                                      colorScheme.primary,
                                    ),
                                    filled: true,
                                    fillColor:
                                    colorScheme.surface,
                                    border:
                                    OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                    ),
                                    enabledBorder:
                                    OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: colorScheme.outline
                                            .withOpacity(.35),
                                      ),
                                    ),
                                    focusedBorder:
                                    OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color:
                                        colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder:
                                    OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color:
                                        colorScheme.error,
                                      ),
                                    ),
                                    focusedErrorBorder:
                                    OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color:
                                        colorScheme.error,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Email is required';
                                    }

                                    if (!value.contains('@')) {
                                      return 'Invalid email address';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 22),

                                // =================================
                                // SEND RESET LINK
                                // =================================

                                SizedBox(
                                  height: width < 600 ? 50 : 54,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                    _loading
                                        ? null
                                        : _resetPassword,
                                    icon: _loading
                                        ? const SizedBox.shrink()
                                        : const Icon(
                                      Icons.send_outlined,
                                      size: 19,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      colorScheme.primary,
                                      foregroundColor:
                                      colorScheme.onPrimary,
                                      disabledBackgroundColor:
                                      colorScheme.primary
                                          .withOpacity(.45),
                                      elevation: 0,
                                      shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(14),
                                      ),
                                    ),
                                    label: _loading
                                        ? SizedBox(
                                      width: 23,
                                      height: 23,
                                      child:
                                      CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color:
                                        colorScheme.onPrimary,
                                      ),
                                    )
                                        : const Text(
                                      'Send Reset Link',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // =========================================
                        // BACK
                        // =========================================

                        TextButton.icon(
                          onPressed: _loading
                              ? null
                              : () {
                            context.pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            size: 18,
                          ),
                          label: const Text(
                            'Back to Login',
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor:
                            colorScheme.primary,
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // =========================================
                        // SECURITY INFORMATION
                        // =========================================

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary
                                .withOpacity(.06),
                            borderRadius:
                            BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.primary
                                  .withOpacity(.10),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  'A password reset link will be sent '
                                      'to your registered email address.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colorScheme.onSurface
                                        .withOpacity(.60),
                                    fontSize: 11.5,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}