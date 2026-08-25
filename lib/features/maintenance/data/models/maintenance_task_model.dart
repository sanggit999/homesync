import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_task_model.freezed.dart';
part 'maintenance_task_model.g.dart';

/// Data Model đại diện cho bảng 'maintenance_tasks' (DTO với Freezed & JsonSerializable)
@freezed
abstract class MaintenanceTaskModel with _$MaintenanceTaskModel {
  const factory MaintenanceTaskModel({
    required String id,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'item_name') String? itemName,
    @JsonKey(name: 'item_location') String? itemLocation,
    @JsonKey(name: 'task_name') required String taskName,
    @JsonKey(name: 'frequency_months') required int frequencyMonths,
    @JsonKey(name: 'last_completed_at') DateTime? lastCompletedAt,
    @JsonKey(name: 'next_due_date') required DateTime nextDueDate,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @Default('medium') String priority,
    @JsonKey(name: 'technician_name') String? technicianName,
    @JsonKey(name: 'technician_phone') String? technicianPhone,
    @JsonKey(name: 'estimated_cost') double? estimatedCost,
    double? cost,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _MaintenanceTaskModel;

  factory MaintenanceTaskModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceTaskModelFromJson(json);
}
