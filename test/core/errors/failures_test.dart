import 'package:flutter_test/flutter_test.dart';
import 'package:home_sync/core/errors/failures.dart';

void main() {
  group('Failures Test', () {
    test('NetworkFailure should have default friendly Vietnamese message', () {
      const failure = NetworkFailure();
      expect(failure.message, 'Không có kết nối mạng. Vui lòng kiểm tra Wi-Fi/4G.');
      expect(failure.toString(), 'Không có kết nối mạng. Vui lòng kiểm tra Wi-Fi/4G.');
    });

    test('TimeoutFailure should have default friendly Vietnamese message', () {
      const failure = TimeoutFailure();
      expect(failure.message, 'Kết nối máy chủ quá hạn (15s). Vui lòng thử lại.');
      expect(failure.toString(), 'Kết nối máy chủ quá hạn (15s). Vui lòng thử lại.');
    });
  });
}
