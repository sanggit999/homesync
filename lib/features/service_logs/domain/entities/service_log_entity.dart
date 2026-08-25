/// Entity đại diện cho Nhật ký chi phí sửa chữa / bảo dưỡng trong tầng Domain
class ServiceLogEntity {
  const ServiceLogEntity({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.serviceType, // 'maintenance', 'repair', 'replacement', 'warranty_claim'
    required this.title,
    required this.serviceDate,
    required this.cost,
    this.taskId,
    this.itemName,
    this.technicianName,
    this.technicianPhone,
    this.receiptImageUrl,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String itemId;
  final String? taskId;
  final String? itemName;

  final String serviceType;
  final String title;
  final DateTime serviceDate;
  final double cost;

  final String? technicianName;
  final String? technicianPhone;
  final String? receiptImageUrl;
  final String? notes;
  final DateTime? createdAt;
}
