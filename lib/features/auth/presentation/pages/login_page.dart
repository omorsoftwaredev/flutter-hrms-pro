import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===============================================================
  // LOGIN
  // ===============================================================

  Future<void> _login() async {
    // // developer login
    // _usernameController.text = 'developeromor';
    // _passwordController.text = 'developeromor';

    // // Walton Company owner login
    // _usernameController.text = 'waltonomor';
    // _passwordController.text = 'waltonomor';

    // // City Company owner login
    // _usernameController.text = 'cityomor';
    // _passwordController.text = 'cityomor';

    // Employee login
    _usernameController.text = 'omoromor';
    _passwordController.text = 'omoromor1';

    // // City Employee login
    // _usernameController.text = 'cgomor';
    // _passwordController.text = 'cgomor1';

    // // Supervisor login
    // _usernameController.text = 'mowser';
    // _passwordController.text = 'mowser';

    // // City Supervisor login
    // _usernameController.text = 'manikbhai';
    // _passwordController.text = 'manik123456';

    final username = _usernameController.text.trim();
    final passwordHash = _passwordController.text;

    if (username.isEmpty || passwordHash.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username and Password are required.',
          ),
        ),
      );
      return;
    }

    try {
      await ref
          .read(loginControllerProvider)
          .login(
        context: context,
        username: username,
        passwordHash: passwordHash,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  // ===============================================================
  // BUILD
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loginLoadingProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final size = MediaQuery.sizeOf(context);

    // =============================================================
    // RESPONSIVE BREAKPOINTS
    // =============================================================

    final bool isMobile = size.width < 600;
    final bool isTablet =
        size.width >= 600 && size.width < 1000;
    final bool isDesktop = size.width >= 1000;

    final double horizontalPadding = isMobile
        ? 18
        : isTablet
        ? 32
        : 40;

    final double verticalPadding = isMobile
        ? 20
        : isTablet
        ? 32
        : 48;

    final double cardPadding = isMobile
        ? 22
        : isTablet
        ? 32
        : 40;

    final double logoSize = isMobile
        ? 78
        : isTablet
        ? 86
        : 94;

    final double logoIconSize = isMobile
        ? 40
        : isTablet
        ? 44
        : 48;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),

                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 480,
                  ),

                  child: Card(
                    elevation: theme.brightness == Brightness.dark
                        ? 0
                        : 3,

                    shadowColor:
                    colorScheme.shadow.withOpacity(.12),

                    color: colorScheme.surface,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(24),

                      side: BorderSide(
                        color: colorScheme.outlineVariant
                            .withOpacity(.65),
                      ),
                    ),

                    child: Padding(
                      padding: EdgeInsets.all(cardPadding),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.stretch,

                        children: [
                          // =========================================
                          // LOGO
                          // =========================================

                          Center(
                            child: Container(
                              width: logoSize,
                              height: logoSize,

                              decoration: BoxDecoration(
                                color: colorScheme.primary
                                    .withOpacity(.10),

                                shape: BoxShape.circle,

                                border: Border.all(
                                  color: colorScheme.primary
                                      .withOpacity(.10),
                                ),
                              ),

                              child: Icon(
                                Icons.apartment_rounded,

                                size: logoIconSize,

                                color:
                                colorScheme.primary,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: isMobile ? 20 : 24,
                          ),

                          // =========================================
                          // APP NAME
                          // =========================================

                          Text(
                            'Flutter HRMS Pro',

                            textAlign: TextAlign.center,

                            style: textTheme.headlineSmall
                                ?.copyWith(
                              fontSize:
                              isMobile ? 24 : 27,

                              fontWeight:
                              FontWeight.w800,

                              letterSpacing: -.6,

                              color:
                              colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 7),

                          // =========================================
                          // APP DESCRIPTION
                          // =========================================

                          Text(
                            'Employee Management System',

                            textAlign: TextAlign.center,

                            style: textTheme.bodyMedium
                                ?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,

                              fontSize:
                              isMobile ? 13 : 14,
                            ),
                          ),

                          SizedBox(
                            height: isMobile ? 30 : 36,
                          ),

                          // =========================================
                          // WELCOME
                          // =========================================

                          Text(
                            'Welcome Back',

                            style:
                            textTheme.titleLarge?.copyWith(
                              fontSize:
                              isMobile ? 21 : 23,

                              fontWeight:
                              FontWeight.w700,

                              color:
                              colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Sign in to continue to your account.',

                            style:
                            textTheme.bodySmall?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant,

                              fontSize:
                              isMobile ? 12 : 13,
                            ),
                          ),

                          SizedBox(
                            height: isMobile ? 20 : 24,
                          ),

                          // =========================================
                          // USERNAME
                          // =========================================

                          _buildTextField(
                            context: context,
                            controller:
                            _usernameController,
                            enabled: !loading,
                            label: 'Username / Email',
                            hint:
                            'Enter username or email',
                            icon:
                            Icons.person_outline_rounded,
                            keyboardType:
                            TextInputType.emailAddress,
                            textInputAction:
                            TextInputAction.next,
                          ),

                          const SizedBox(height: 16),

                          // =========================================
                          // PASSWORD
                          // =========================================

                          _buildTextField(
                            context: context,
                            controller:
                            _passwordController,
                            enabled: !loading,
                            label: 'Password',
                            hint: 'Enter your password',
                            icon:
                            Icons.lock_outline_rounded,
                            obscureText:
                            _obscurePassword,
                            textInputAction:
                            TextInputAction.done,
                            onSubmitted: (_) {
                              if (!loading) {
                                _login();
                              }
                            },
                            suffixIcon: IconButton(
                              tooltip:
                              _obscurePassword
                                  ? 'Show password'
                                  : 'Hide password',
                              onPressed: loading
                                  ? null
                                  : () {
                                setState(() {
                                  _obscurePassword =
                                  !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons
                                    .visibility_outlined
                                    : Icons
                                    .visibility_off_outlined,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: isMobile ? 22 : 26,
                          ),

                          // =========================================
                          // LOGIN BUTTON
                          // =========================================

                          SizedBox(
                            height: isMobile ? 52 : 55,

                            child: ElevatedButton(
                              onPressed:
                              loading ? null : _login,

                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                colorScheme.primary,

                                foregroundColor:
                                colorScheme.onPrimary,

                                disabledBackgroundColor:
                                colorScheme.primary
                                    .withOpacity(.45),

                                disabledForegroundColor:
                                colorScheme.onPrimary
                                    .withOpacity(.80),

                                elevation: 0,

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    14,
                                  ),
                                ),
                              ),

                              child: loading
                                  ? SizedBox(
                                height: 23,
                                width: 23,

                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2.5,
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
                                    Icons.login_rounded,
                                    size: 20,
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                      FontWeight.w700,
                                      letterSpacing:
                                      .5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: isMobile ? 20 : 24,
                          ),

                          // =========================================
                          // SECURITY FOOTER
                          // =========================================

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),

                            decoration: BoxDecoration(
                              color: colorScheme.primary
                                  .withOpacity(.05),

                              borderRadius:
                              BorderRadius.circular(12),

                              border: Border.all(
                                color: colorScheme.primary
                                    .withOpacity(.08),
                              ),
                            ),

                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,

                              children: [
                                Icon(
                                  Icons.verified_outlined,
                                  size: 16,
                                  color: colorScheme
                                      .onSurfaceVariant,
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  'Secure HRMS Portal',
                                  style: textTheme.bodySmall
                                      ?.copyWith(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                    fontWeight:
                                    FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // =========================================
                          // VERSION
                          // =========================================

                          Text(
                            'Version 0.1.0',

                            textAlign: TextAlign.center,

                            style:
                            textTheme.labelSmall?.copyWith(
                              color: colorScheme
                                  .onSurfaceVariant
                                  .withOpacity(.70),
                            ),
                          ),
                        ],
                      ),
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

  // ===============================================================
  // TEXT FIELD
  // ===============================================================

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required bool enabled,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    ValueChanged<String>? onSubmitted,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final borderRadius = BorderRadius.circular(14);

    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: Icon(
          icon,
          color: colorScheme.onSurfaceVariant,
        ),

        suffixIcon: suffixIcon,

        filled: true,

        fillColor: colorScheme
            .surfaceContainerHighest
            .withOpacity(.35),

        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: colorScheme.outlineVariant
                .withOpacity(.50),
          ),
        ),

        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
        ),

        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant
              .withOpacity(.55),
        ),
      ),
    );
  }
}