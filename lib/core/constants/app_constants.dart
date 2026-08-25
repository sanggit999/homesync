/// Các hằng số cấu hình toàn ứng dụng HomeSync
class AppConstants {
  AppConstants._();

  // Ngưỡng cảnh báo bảo hành
  static const int warningThresholdDays = 30;

  // Tùy chọn nhắc trước mặc định
  static const int defaultReminderDays = 7;
  static const List<int> reminderDayOptions = [3, 7, 14, 30];

  // Nén ảnh tải lên
  static const int imageQuality = 80;
  static const double maxImageWidth = 1920.0;
  static const double maxImageHeight = 1920.0;

  // Tùy chọn danh mục mặc định
  static const List<String> defaultLocations = [
    'Phòng khách',
    'Phòng ngủ',
    'Bếp',
    'Nhà tắm',
    'Ban công',
    'Sân vườn',
    'Ga-ra / Xe',
    'Nơi làm việc',
  ];

  // Độ trễ tìm kiếm (Debounce)
  static const Duration searchDebounce = Duration(milliseconds: 300);
}
