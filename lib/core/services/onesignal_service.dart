import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../config/app_config.dart';

/// Dịch vụ quản lý thông báo đẩy OneSignal
class OneSignalService {
  OneSignalService._();

  /// Khởi tạo OneSignal SDK
  static Future<void> initialize() async {
    try {
      if (kDebugMode) {
        OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      }

      // Khởi tạo với App ID
      OneSignal.initialize(AppConfig.oneSignalAppId);

      // Yêu cầu quyền nhận thông báo
      await OneSignal.Notifications.requestPermission(true);
    } catch (e) {
      debugPrint('Error initializing OneSignal: $e');
    }
  }

  /// Lấy Subscription ID / Player ID của người dùng hiện tại
  static String? getPlayerId() {
    try {
      return OneSignal.User.pushSubscription.id;
    } catch (e) {
      debugPrint('Error getting OneSignal Player ID: $e');
      return null;
    }
  }

  /// Gán User ID để dễ quản lý theo tài khoản
  static Future<void> loginUser(String userId) async {
    try {
      await OneSignal.login(userId);
    } catch (e) {
      debugPrint('Error logging in OneSignal user: $e');
    }
  }

  /// Đăng xuất OneSignal khi user đăng xuất
  static Future<void> logoutUser() async {
    try {
      await OneSignal.logout();
    } catch (e) {
      debugPrint('Error logging out OneSignal user: $e');
    }
  }
}
