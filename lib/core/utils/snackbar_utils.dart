import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:home_sync/core/constants/app_colors.dart';

/// Helper chuẩn hiển thị Root SnackBar thống nhất toàn ứng dụng HomeSync
class AppSnackBar {
  AppSnackBar._();

  /// Global key gắn vào MaterialApp để hiển thị SnackBar toàn cục không cần BuildContext
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Hiển thị thông báo Thành công (Màu xanh Emerald)
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      messenger: ScaffoldMessenger.of(context),
      message: message,
      backgroundColor: AppColors.success,
      icon: LucideIcons.circleCheck,
      duration: duration,
      action: action,
    );
  }

  /// Hiển thị thông báo Lỗi / Cảnh báo đỏ (Màu đỏ Coral)
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      messenger: ScaffoldMessenger.of(context),
      message: message,
      backgroundColor: AppColors.error,
      icon: LucideIcons.circleAlert,
      duration: duration,
      action: action,
    );
  }

  /// Hiển thị thông báo Cảnh báo (Màu vàng Amber)
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      messenger: ScaffoldMessenger.of(context),
      message: message,
      backgroundColor: AppColors.warning,
      icon: LucideIcons.triangleAlert,
      duration: duration,
      action: action,
    );
  }

  /// Hiển thị thông báo Thông tin / Trung tính (Màu xanh Primary)
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    _show(
      messenger: ScaffoldMessenger.of(context),
      message: message,
      backgroundColor: AppColors.primary,
      icon: LucideIcons.info,
      duration: duration,
      action: action,
    );
  }

  // ==========================================
  // Global helpers (khi không có BuildContext)
  // ==========================================

  static void showSuccessGlobal(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final state = messengerKey.currentState;
    if (state != null) {
      _show(
        messenger: state,
        message: message,
        backgroundColor: AppColors.success,
        icon: LucideIcons.circleCheck,
        duration: duration,
        action: action,
      );
    }
  }

  static void showErrorGlobal(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final state = messengerKey.currentState;
    if (state != null) {
      _show(
        messenger: state,
        message: message,
        backgroundColor: AppColors.error,
        icon: LucideIcons.circleAlert,
        duration: duration,
        action: action,
      );
    }
  }

  /// Hàm cốt lõi tạo SnackBar theo chuẩn Modern Minimalist Design
  static void _show({
    required ScaffoldMessengerState messenger,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
    SnackBarAction? action,
  }) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: duration,
        action: action,
      ),
    );
  }
}
