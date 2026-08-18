/// ===============================================================
/// Flutter HRMS Pro
/// Splash Page
///
/// Version : 2.1.0
///
/// UI Improvements:
/// - Theme aware
/// - Light / Dark mode support
/// - Responsive design
/// - Mobile / Tablet / Desktop friendly
///
/// Functionality: UNCHANGED
/// ===============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/current_user.dart';
import '../../../core/auth/current_user_provider.dart';
import '../../../core/router/redirect_helper.dart';
import '../../../core/router/route_paths.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  // =============================================================
  // LOAD
  // =============================================================

  Future<void> _load() async {
    // Splash Delay
    await Future.delayed(const Duration(seconds: 1));

    try {
      final CurrentUser? user = await ref
          .read(authRepositoryProvider)
          .currentUser();

      if (user != null) {
        ref.read(currentUserProvider.notifier).login(user);

        if (!mounted) return;

        context.go(RedirectHelper.initial(user));

        return;
      }

      if (!mounted) return;

      context.go(RoutePaths.login);
    } catch (e) {
      if (!mounted) return;

      context.go(RoutePaths.login);
    }
  }

  // =============================================================
  // RESPONSIVE CONTENT WIDTH
  // =============================================================

  double _contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return width * .72;
    }

    if (width < 1000) {
      return 320;
    }

    return 360;
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 40,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: _contentWidth(context)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // =================================================
                    // APP LOGO
                    // =================================================
                    Container(
                      width: isMobile ? 92 : 108,
                      height: isMobile ? 92 : 108,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(.10),
                        borderRadius: BorderRadius.circular(isMobile ? 26 : 30),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(.12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(
                              isDark ? .16 : .10,
                            ),
                            blurRadius: 28,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.business_center_outlined,
                        size: isMobile ? 46 : 54,
                        color: colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // =================================================
                    // APP NAME
                    // =================================================
                    Text(
                      'HRMS Pro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: isMobile ? 28 : 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.5,
                      ),
                    ),

                    const SizedBox(height: 7),

                    // =================================================
                    // SUBTITLE
                    // =================================================
                    Text(
                      'Human Resource Management System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(.58),
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 34),

                    // =================================================
                    // LOADING INDICATOR
                    // =================================================
                    SizedBox(
                      width: isMobile ? 30 : 34,
                      height: isMobile ? 30 : 34,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =================================================
                    // LOADING TEXT
                    // =================================================
                    Text(
                      'Loading...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(.48),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
