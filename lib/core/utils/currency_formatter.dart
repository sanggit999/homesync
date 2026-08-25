import 'package:intl/intl.dart';

/// Định dạng và phân tích tiền tệ an toàn (VND / Tùy chỉnh)
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _vndFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  /// Format số tiền sang dạng chuỗi (VD: 15000000 -> "15.000.000 đ")
  static String format(num? amount) {
    if (amount == null) return '0 đ';
    return _vndFormat.format(amount).trim();
  }

  /// Format số tiền dạng ngắn gọn (VD: 15000000 -> "15 triệu", 500000 -> "500k")
  static String formatCompact(num? amount) {
    if (amount == null || amount == 0) return '0 đ';
    if (amount >= 1000000000) {
      final b = (amount / 1000000000).toStringAsFixed(1).replaceAll('.0', '');
      return '$b tỷ';
    } else if (amount >= 1000000) {
      final m = (amount / 1000000).toStringAsFixed(1).replaceAll('.0', '');
      return '$m triệu';
    } else if (amount >= 1000) {
      final k = (amount / 1000).toStringAsFixed(0);
      return '$k k';
    }
    return format(amount);
  }

  /// Phân tích chuỗi nhập tay sang dạng số an toàn
  static double? parse(String? input) {
    if (input == null || input.trim().isEmpty) return null;
    // Bỏ tất cả ký tự không phải số
    final cleanStr = input.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanStr);
  }
}
