import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Màn hình Splash Screen với hiệu ứng chuyển động mượt mà & định tuyến thông minh
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _minDelayPassed = false;

  @override
  void initState() {
    super.initState();

    // Khởi tạo hiệu ứng chuyển động mềm mại
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // Đảm bảo thời gian hiển thị 3 giây theo yêu cầu
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() => _minDelayPassed = true);
        _handleNavigation(context.read<AuthCubit>().state);
      }
    });

    // Kích hoạt kiểm tra phiên đăng nhập
    context.read<AuthCubit>().checkAuthStatus();
  }

  void _handleNavigation(AuthState state) {
    if (!_minDelayPassed) return;

    if (state is Authenticated) {
      context.go(AppRoutes.home);
    } else if (state is Unauthenticated || state is AuthFailureState) {
      context.go(AppRoutes.welcome);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        _handleNavigation(state);
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        body: Stack(
          children: [
            // Background Ambient Glow
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryLight.withValues(alpha: isDark ? 0.05 : 0.5),
                ),
              ),
            ),

            // Main Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated App Icon Container
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primaryDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          LucideIcons.home,
                          size: 54,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Brand Title
                      const Text(
                        'HomeSync',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Brand Subtitle
                      Text(
                        'Quản lý Bảo hành & Tài sản Gia đình',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Minimal Loading Indicator
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer Version
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Phiên bản 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
                        : AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
