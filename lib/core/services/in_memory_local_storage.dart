import 'package:supabase_flutter/supabase_flutter.dart';

/// In-Memory LocalStorage cho Supabase:
/// Chỉ lưu trữ phiên đăng nhập và Token trên RAM trong suốt thời gian ứng dụng đang chạy.
/// Tuyệt đối KHÔNG ghi bất kỳ token hay dữ liệu phiên nào xuống ổ đĩa (Disk/Flash Storage / SharedPreferences).
/// Khi đóng ứng dụng hoặc kill process, RAM được giải phóng hoàn toàn và token biến mất 100%.
class InMemoryLocalStorage extends LocalStorage {
  InMemoryLocalStorage();

  String? _sessionString;

  @override
  Future<void> initialize() async {
    // Khởi tạo bộ nhớ tạm RAM (không đọc từ Disk)
  }

  @override
  Future<bool> hasAccessToken() async {
    return _sessionString != null;
  }

  @override
  Future<String?> accessToken() async {
    return _sessionString;
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    _sessionString = persistSessionString;
  }

  @override
  Future<void> removePersistedSession() async {
    _sessionString = null;
  }
}
