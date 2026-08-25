import 'package:home_sync/core/constants/app_constants.dart';

/// Trạng thái bảo hành chuẩn hóa
enum WarrantyStatus {
  good,         // Còn hạn tốt (> 30 ngày)
  expiringSoon, // Sắp hết hạn (<= 30 ngày và >= 0)
  expired,      // Đã hết hạn (< 0 ngày)
}

/// Tiện ích tính toán nghiệp vụ bảo hành & bảo trì
class WarrantyCalculator {
  WarrantyCalculator._();

  /// Tính số ngày còn lại tính từ thời điểm hiện tại đến ngày hết hạn
  static int calculateDaysRemaining(DateTime expiryDate, [DateTime? currentDate]) {
    final now = currentDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return target.difference(today).inDays;
  }

  /// Xác định trạng thái bảo hành
  static WarrantyStatus getStatus(DateTime expiryDate, [DateTime? currentDate]) {
    final days = calculateDaysRemaining(expiryDate, currentDate);
    if (days < 0) {
      return WarrantyStatus.expired;
    } else if (days <= AppConstants.warningThresholdDays) {
      return WarrantyStatus.expiringSoon;
    } else {
      return WarrantyStatus.good;
    }
  }

  /// Tính phần trăm tiến độ đã trôi qua (0.0 -> 1.0)
  static double calculateProgress({
    required DateTime purchaseDate,
    required DateTime expiryDate,
    DateTime? currentDate,
  }) {
    final now = currentDate ?? DateTime.now();
    final totalDays = expiryDate.difference(purchaseDate).inDays;
    if (totalDays <= 0) return 1.0;

    final elapsedDays = now.difference(purchaseDate).inDays;
    if (elapsedDays <= 0) return 0.0;
    if (elapsedDays >= totalDays) return 1.0;

    return elapsedDays / totalDays;
  }

  /// Tính ngày hết hạn dựa trên ngày mua và số tháng bảo hành
  static DateTime calculateExpiryDate({
    required DateTime purchaseDate,
    required int warrantyMonths,
  }) {
    final year = purchaseDate.year + (purchaseDate.month + warrantyMonths - 1) ~/ 12;
    final month = (purchaseDate.month + warrantyMonths - 1) % 12 + 1;
    
    // Xử lý ngày cuối tháng khi chuyển tháng (VD: 31/01 + 1 tháng -> 28/02)
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final day = purchaseDate.day > daysInMonth ? daysInMonth : purchaseDate.day;

    return DateTime(year, month, day);
  }

  /// Tính ngày đến hạn bảo trì kế tiếp dựa trên chu kỳ tháng
  static DateTime calculateNextDueDate({
    required DateTime lastDate,
    required int frequencyMonths,
  }) {
    return calculateExpiryDate(purchaseDate: lastDate, warrantyMonths: frequencyMonths);
  }
}
