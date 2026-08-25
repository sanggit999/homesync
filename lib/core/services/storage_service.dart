import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/core/config/app_config.dart';
import 'package:home_sync/core/constants/app_constants.dart';

/// Dịch vụ tải và quản lý hình ảnh / tài liệu trên Supabase Storage
class StorageService {
  StorageService({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  final ImagePicker _picker = ImagePicker();

  /// Chụp ảnh từ Camera hoặc chọn từ Thư viện với chất lượng nén tối ưu
  Future<XFile?> pickImage({required ImageSource source}) async {
    return _picker.pickImage(
      source: source,
      imageQuality: AppConstants.imageQuality,
      maxWidth: AppConstants.maxImageWidth,
      maxHeight: AppConstants.maxImageHeight,
    );
  }

  /// Tải tệp lên Supabase Storage bucket 'receipts' và trả về Public URL
  Future<String> uploadFile({
    required String path,
    required dynamic fileSource, // File hoặc Uint8List
    String? mimeType,
  }) async {
    final storage = _client.storage.from(AppConfig.receiptsBucket);
    
    if (fileSource is File) {
      final bytes = await fileSource.readAsBytes();
      await storage.uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(
          contentType: mimeType ?? 'image/jpeg',
          upsert: true,
        ),
      );
    } else if (fileSource is Uint8List) {
      await storage.uploadBinary(
        path,
        fileSource,
        fileOptions: FileOptions(
          contentType: mimeType ?? 'image/jpeg',
          upsert: true,
        ),
      );
    } else {
      throw ArgumentError('fileSource must be File or Uint8List');
    }

    // Lấy Public CDN URL
    final publicUrl = storage.getPublicUrl(path);
    return publicUrl;
  }

  /// Xóa tệp khỏi Storage
  Future<void> deleteFile(String path) async {
    await _client.storage.from(AppConfig.receiptsBucket).remove([path]);
  }
}
