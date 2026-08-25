import 'package:intl/intl.dart';

/// Định dạng ngày tháng chuẩn hóa cho thị trường Việt Nam & Quốc tế
class DateFormatter {
  DateFormatter._();

  static final DateFormat _vietnameseDate = DateFormat('dd/MM/yyyy');
  static final DateFormat _vietnameseDateTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _monthYear = DateFormat('MM/yyyy');

  /// Định dạng dd/MM/yyyy (VD: 25/08/2026)
  static String format(DateTime? date) {
    if (date == null) return '--/--/----';
    return _vietnameseDate.format(date.toLocal());
  }

  /// Định dạng dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '--/--/---- --:--';
    return _vietnameseDateTime.format(dateTime.toLocal());
  }

  /// Định dạng Tháng/Năm (VD: 08/2026)
  static String formatMonthYear(DateTime? date) {
    if (date == null) return '--/----';
    return _monthYear.format(date.toLocal());
  }

  /// Hiển thị thời gian tương đối thân thiện
  static String formatRelative(DateTime? targetDate) {
    if (targetDate == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final difference = target.difference(today).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Ngày mai';
    } else if (difference == -1) {
      return 'Hôm qua';
    } else if (difference > 0) {
      return 'Còn $difference ngày';
    } else {
      return 'Quá hạn ${-difference} ngày';
    }
  }
}
