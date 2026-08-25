import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_log_model.freezed.dart';
part 'service_log_model.g.dart';

/// Data Model đại diện cho bảng 'service_logs' (DTO với Freezed & JsonSerializable)
@freezed
abstract class ServiceLogModel with _$ServiceLogModel {
  const factory ServiceLogModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'task_id') String? taskId,
    @JsonKey(name: 'item_name') String? itemName,
    @JsonKey(name: 'service_type') required String serviceType,
    required String title,
    @JsonKey(name: 'service_date') required DateTime serviceDate,
    required double cost,
    @JsonKey(name: 'technician_name') String? technicianName,
    @JsonKey(name: 'technician_phone') String? technicianPhone,
    @JsonKey(name: 'receipt_image_url') String? receiptImageUrl,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ServiceLogModel;

  factory ServiceLogModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceLogModelFromJson(json);
}
