import 'package:flutter_test/flutter_test.dart';
import 'package:home_sync/core/utils/currency_formatter.dart';
import 'package:home_sync/core/utils/date_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('format returns VND formatted string', () {
      expect(CurrencyFormatter.format(15000000), contains('15.000.000'));
      expect(CurrencyFormatter.format(0), contains('0'));
      expect(CurrencyFormatter.format(null), contains('0'));
    });

    test('formatCompact formats millions and billions correctly', () {
      expect(CurrencyFormatter.formatCompact(15000000), equals('15 triệu'));
      expect(CurrencyFormatter.formatCompact(2500000000), equals('2.5 tỷ'));
      expect(CurrencyFormatter.formatCompact(500000), equals('500 k'));
    });

    test('parse removes special characters and parses integer safely', () {
      expect(CurrencyFormatter.parse('15.000.000 đ'), equals(15000000.0));
      expect(CurrencyFormatter.parse(' 2,500,000 '), equals(2500000.0));
      expect(CurrencyFormatter.parse('abc'), isNull);
      expect(CurrencyFormatter.parse(''), isNull);
    });
  });

  group('DateFormatter', () {
    test('format formats DateTime to dd/MM/yyyy', () {
      final date = DateTime(2026, 8, 25);
      expect(DateFormatter.format(date), equals('25/08/2026'));
      expect(DateFormatter.format(null), equals('--/--/----'));
    });

    test('formatRelative provides intuitive human readable text', () {
      final today = DateTime.now();
      expect(DateFormatter.formatRelative(today), equals('Hôm nay'));
      
      final tomorrow = today.add(const Duration(days: 1));
      expect(DateFormatter.formatRelative(tomorrow), equals('Ngày mai'));

      final in5Days = today.add(const Duration(days: 5));
      expect(DateFormatter.formatRelative(in5Days), equals('Còn 5 ngày'));
    });
  });
}
