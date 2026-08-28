import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formatter tự động định dạng số tiền VNĐ phân cách hàng nghìn bằng dấu chấm (.)
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Loại bỏ toàn bộ ký tự không phải số
    final cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanText.isEmpty) {
      return const TextEditingValue();
    }

    final number = int.tryParse(cleanText);
    if (number == null) {
      return oldValue;
    }

    final formatted = _formatter.format(number).replaceAll(',', '.');

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static const List<String> _digits = [
    'không',
    'một',
    'hai',
    'ba',
    'bốn',
    'năm',
    'sáu',
    'bảy',
    'tám',
    'chín',
  ];

  /// Đọc khối 3 chữ số tiếng Việt
  static String _readTriple(int number, bool readZeroHundred) {
    final tram = number ~/ 100;
    final chuc = (number % 100) ~/ 10;
    final donVi = number % 10;

    if (tram == 0 && chuc == 0 && donVi == 0) return '';

    String result = '';
    if (tram > 0 || readZeroHundred) {
      result += '${_digits[tram]} trăm ';
    }

    if (chuc == 0 && donVi > 0) {
      if (tram > 0 || readZeroHundred) {
        result += 'lẻ ${_digits[donVi]}';
      } else {
        result += _digits[donVi];
      }
    } else if (chuc == 1) {
      result += 'mười ';
      if (donVi == 1) {
        result += 'một';
      } else if (donVi == 5) {
        result += 'lăm';
      } else if (donVi > 0) {
        result += _digits[donVi];
      }
    } else if (chuc > 1) {
      result += '${_digits[chuc]} mươi ';
      if (donVi == 1) {
        result += 'mốt';
      } else if (donVi == 5) {
        result += 'lăm';
      } else if (donVi > 0) {
        result += _digits[donVi];
      }
    }

    return result.trim();
  }

  /// Đọc số tiền thành chữ tiếng Việt chuẩn xác (VD: "Hai trăm nghìn đồng", "Hai mươi triệu đồng")
  static String formatVndInWords(double amount) {
    final num = amount.toInt();
    if (num <= 0) return '';
    if (num == 0) return 'Không đồng';

    const units = ['', 'nghìn', 'triệu', 'tỷ', 'nghìn tỷ', 'triệu tỷ'];
    final List<String> parts = [];
    int unitIndex = 0;

    int temp = num;
    while (temp > 0) {
      final triple = temp % 1000;
      temp = temp ~/ 1000;

      if (triple > 0) {
        final tripleStr = _readTriple(triple, temp > 0);
        final unit = units[unitIndex];
        if (unit.isNotEmpty) {
          parts.insert(0, '$tripleStr $unit');
        } else {
          parts.insert(0, tripleStr);
        }
      }
      unitIndex++;
    }

    String text = parts.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.isEmpty) return '';

    // Viết hoa chữ cái đầu tiên và gắn hậu tố "đồng"
    text = '${text[0].toUpperCase()}${text.substring(1)} đồng';
    return text;
  }

  /// Tương thích ngược
  static String formatVndCompact(double amount) => formatVndInWords(amount);
}
