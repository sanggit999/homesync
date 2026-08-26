import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';
import 'package:home_sync/core/router/app_routes.dart';
import 'package:home_sync/core/utils/snackbar_utils.dart';
import 'package:home_sync/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:home_sync/features/auth/presentation/widgets/auth_hero_logo.dart';

/// Màn hình Chào đón & Xác thực 1 chạm (Guest Mode & Google Sign-In)
class AuthWelcomePage extends StatelessWidget {
  const AuthWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(AppRoutes.home);
        } else if (state is AuthFailureState) {
          AppSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  const Spacer(),
                  const AuthHeroLogo(),
                  const SizedBox(height: 28),
                  Text(
                    'HomeSync',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Quản lý tài sản & bảo hành thiết bị gia đình\nThông minh, Tinh gọn, Chuẩn Apple',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                  const Spacer(),

                  // 1. Nút "Bắt đầu sử dụng ngay" (Guest Mode 1 chạm)
                  ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => context.read<AuthCubit>().signInAnonymously(),
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(LucideIcons.zap, size: 20),
                    label: const Text(
                      'Bắt đầu sử dụng ngay',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 2. Nút "Tiếp tục với Google"
                  OutlinedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () => context.read<AuthCubit>().signInWithGoogle(),
                    icon: const Icon(LucideIcons.globe, size: 20),
                    label: const Text(
                      'Tiếp tục với Google',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Trải nghiệm tức thì không cần đăng ký.\nDữ liệu được đồng bộ khi bạn liên kết tài khoản sau.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
