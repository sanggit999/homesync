import 'package:add_2_calendar/add_2_calendar.dart';

/// Dịch vụ đồng bộ sự kiện bảo trì vào Lịch điện thoại (Apple Calendar / Google Calendar)
class CalendarService {
  CalendarService._();

  /// Thêm lịch bảo trì vào ứng dụng Calendar của thiết bị
  static Future<bool> addMaintenanceEvent({
    required String title,
    required String description,
    required DateTime dueDate,
    String? location,
  }) async {
    final event = Event(
      title: '🛠️ [HomeSync] $title',
      description: description,
      location: location ?? 'Tại nhà',
      startDate: dueDate,
      endDate: dueDate.add(const Duration(hours: 1)),
      allDay: true,
      iosParams: const IOSParams(
        reminder: Duration(days: 1), // Nhắc trước 1 ngày trên iOS
      ),
      androidParams: const AndroidParams(
        emailInvites: [],
      ),
    );

    return Add2Calendar.addEvent2Cal(event);
  }
}
