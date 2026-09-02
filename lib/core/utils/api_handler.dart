import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_sync/core/errors/failures.dart';

/// Hàm Global bọc tất cả request API / DB, tự động áp dụng timeout 15s và chuyển đổi lỗi kỹ thuật bằng Error Code & Strict Typing
Future<Either<Failure, T>> safeApiCall<T>(
  Future<T> Function() action, {
  Duration timeout = const Duration(seconds: 15),
}) async {
  try {
    final result = await action().timeout(timeout);
    return Right(result);
  } on TimeoutException {
    debugPrint('[HOMESYNC NETWORK] ⏳ Request Timeout (${timeout.inSeconds}s)');
    return const Left(TimeoutFailure('Hệ thống phản hồi quá thời gian. Vui lòng thử lại.'));
  } on SocketException catch (e) {
    debugPrint('[HOMESYNC NETWORK] ❌ SocketException: ${e.message} (OS Error: ${e.osError})');
    return const Left(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Wi-Fi hoặc 4G/5G của bạn.'));
  } on http.ClientException catch (e) {
    debugPrint('[HOMESYNC NETWORK] ❌ ClientException: ${e.message} (URI: ${e.uri})');
    return const Left(NetworkFailure('Không thể kết nối đến máy chủ. Vui lòng kiểm tra đường truyền mạng.'));
  } on HttpException catch (e) {
    debugPrint('[HOMESYNC NETWORK] ❌ HttpException: ${e.message} (URI: ${e.uri})');
    return const Left(NetworkFailure('Lỗi đường truyền mạng. Vui lòng thử lại.'));
  } on HandshakeException catch (e) {
    debugPrint('[HOMESYNC NETWORK] ❌ HandshakeException: ${e.message}');
    return const Left(NetworkFailure('Kết nối bị gián đoạn do mạng chập chờn. Vui lòng thử lại.'));
  } on TlsException catch (e) {
    debugPrint('[HOMESYNC NETWORK] ❌ TlsException: ${e.message}');
    return const Left(NetworkFailure('Kết nối bị gián đoạn. Vui lòng thử lại.'));
  } on ArgumentError catch (e) {
    debugPrint('[HOMESYNC CONFIG ERROR] ❌ ArgumentError: ${e.message}');
    return const Left(ServerFailure('Hệ thống đang gặp sự cố kết nối. Vui lòng thử lại sau.'));
  } on FormatException catch (e) {
    debugPrint('[HOMESYNC FORMAT ERROR] ❌ FormatException: ${e.message}');
    return const Left(ServerFailure('Hệ thống đang gặp sự cố xử lý dữ liệu. Vui lòng thử lại sau.'));
  } on AuthException catch (e) {
    debugPrint('[HOMESYNC AUTH ERROR] [${e.statusCode}] (${e.code}) ${e.message}');
    final msg = switch (e.code) {
      'invalid_credentials' || 'invalid_grant' => 'Thông tin đăng nhập không chính xác.',
      'user_already_exists' => 'Tài khoản này đã tồn tại trên hệ thống.',
      'anonymous_provider_disabled' => 'Chế độ đăng nhập dùng thử tạm thời bảo trì.',
      _ => 'Đăng nhập không thành công. Vui lòng thử lại sau.',
    };
    return Left(AuthFailure(msg));
  } on PostgrestException catch (e) {
    debugPrint('[HOMESYNC DB ERROR] [${e.code}] ${e.message} | Details: ${e.details} | Hint: ${e.hint}');
    return const Left(ServerFailure('Không thể xử lý yêu cầu lúc này. Vui lòng thử lại sau.'));
  } on StorageException catch (e) {
    debugPrint('[HOMESYNC STORAGE ERROR] [${e.statusCode}] ${e.message} | Error: ${e.error}');
    return const Left(StorageFailure('Không thể tải tệp lên lúc này. Vui lòng thử lại sau.'));
  } catch (e) {
    debugPrint('[HOMESYNC UNEXPECTED ERROR] $e');
    return const Left(ServerFailure('Hệ thống đang gặp sự cố tạm thời. Vui lòng thử lại sau.'));
  }
}
