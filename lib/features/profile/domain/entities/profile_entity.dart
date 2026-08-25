/// Entity đại diện cho Hồ sơ người dùng trong hệ thống
class ProfileEntity {
  const ProfileEntity({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.oneSignalPlayerId,
    this.reminderDaysBefore = 7,
    this.notifyWarranty = true,
    this.notifyMaintenance = true,
    this.updatedAt,
  });

  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? oneSignalPlayerId;
  final int reminderDaysBefore;
  final bool notifyWarranty;
  final bool notifyMaintenance;
  final DateTime? updatedAt;
}
