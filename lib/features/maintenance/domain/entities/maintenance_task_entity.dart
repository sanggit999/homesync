import 'package:home_sync/core/utils/warranty_calculator.dart';

/// Entity đại diện cho Lịch Bảo Trì / Vệ Sinh Định Kỳ
class MaintenanceTaskEntity {
  const MaintenanceTaskEntity({
    required this.id,
    required this.itemId,
    required this.taskName,
    required this.frequencyMonths,
    required this.nextDueDate,
    this.itemName,
    this.itemLocation,
    this.lastCompletedAt,
    this.isCompleted = false,
    this.priority = 'medium',
    this.technicianName,
    this.technicianPhone,
    this.estimatedCost,
    this.cost,
    this.notes,
    this.createdAt,
  });

  final String id;
  final String itemId;
  final String? itemName;
  final String? itemLocation;

  final String taskName;
  final int frequencyMonths;
  final DateTime? lastCompletedAt;
  final DateTime nextDueDate;
  final bool isCompleted;
  final String priority;

  final String? technicianName;
  final String? technicianPhone;
  final double? estimatedCost;
  final double? cost;
  final String? notes;
  final DateTime? createdAt;

  String get title => taskName;
  DateTime get dueDate => nextDueDate;
  int get intervalMonths => frequencyMonths;

  /// Số ngày còn lại đến hạn bảo trì
  int get remainingDays => WarrantyCalculator.calculateDaysRemaining(nextDueDate);

  /// Quá hạn bảo trì
  bool get isOverdue => remainingDays < 0;

  /// Đến hạn hôm nay
  bool get isDueToday => remainingDays == 0;

  /// Sắp đến hạn trong 7 ngày tới
  bool get isDueSoon => remainingDays > 0 && remainingDays <= 7;
}
