import 'package:flutter_test/flutter_test.dart';
import 'package:home_sync/core/utils/warranty_calculator.dart';

void main() {
  group('WarrantyCalculator', () {
    final fixedCurrentDate = DateTime(2026, 8, 25);

    test('calculateDaysRemaining calculates accurate difference in days', () {
      final expiryIn10Days = DateTime(2026, 9, 4);
      final days = WarrantyCalculator.calculateDaysRemaining(expiryIn10Days, fixedCurrentDate);
      expect(days, equals(10));
    });

    test('getStatus classifies > 30 days as good', () {
      final expiryIn60Days = DateTime(2026, 10, 24);
      final status = WarrantyCalculator.getStatus(expiryIn60Days, fixedCurrentDate);
      expect(status, equals(WarrantyStatus.good));
    });

    test('getStatus classifies <= 30 days and >= 0 as expiringSoon', () {
      final expiryIn20Days = DateTime(2026, 9, 14);
      final status = WarrantyCalculator.getStatus(expiryIn20Days, fixedCurrentDate);
      expect(status, equals(WarrantyStatus.expiringSoon));
    });

    test('getStatus classifies < 0 days as expired', () {
      final expiredYesterday = DateTime(2026, 8, 24);
      final status = WarrantyCalculator.getStatus(expiredYesterday, fixedCurrentDate);
      expect(status, equals(WarrantyStatus.expired));
    });

    test('calculateProgress returns correct ratio between 0.0 and 1.0', () {
      final purchaseDate = DateTime(2026, 1, 1);
      final expiryDate = DateTime(2027, 1, 1); // 365 days
      final halfwayDate = DateTime(2026, 7, 2);

      final progress = WarrantyCalculator.calculateProgress(
        purchaseDate: purchaseDate,
        expiryDate: expiryDate,
        currentDate: halfwayDate,
      );

      expect(progress, greaterThan(0.49));
      expect(progress, lessThan(0.52));
    });

    test('calculateExpiryDate correctly calculates anniversary across leap years and month ends', () {
      final purchaseDate = DateTime(2024, 1, 31);
      // 1 tháng sau ngày 31/01 năm nhuận 2024 -> ngày 29/02/2024
      final expiry = WarrantyCalculator.calculateExpiryDate(
        purchaseDate: purchaseDate,
        warrantyMonths: 1,
      );
      expect(expiry, equals(DateTime(2024, 2, 29)));

      // 12 tháng sau ngày 25/08/2026 -> 25/08/2027
      final oneYearExpiry = WarrantyCalculator.calculateExpiryDate(
        purchaseDate: DateTime(2026, 8, 25),
        warrantyMonths: 12,
      );
      expect(oneYearExpiry, equals(DateTime(2027, 8, 25)));
    });

    test('calculateNextDueDate calculates correctly from last completed date', () {
      final lastCompleted = DateTime(2026, 6, 15);
      final nextDue = WarrantyCalculator.calculateNextDueDate(
        lastDate: lastCompleted,
        frequencyMonths: 6,
      );
      expect(nextDue, equals(DateTime(2026, 12, 15)));
    });
  });
}
