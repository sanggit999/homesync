import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_preset_model.freezed.dart';
part 'maintenance_preset_model.g.dart';

/// Data Model đại diện cho bảng 'maintenance_presets' (DTO với Freezed & JsonSerializable)
@freezed
abstract class MaintenancePresetModel with _$MaintenancePresetModel {
  const factory MaintenancePresetModel({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    @JsonKey(name: 'preset_name') required String presetName,
    @JsonKey(name: 'default_frequency_months') required int defaultFrequencyMonths,
    @JsonKey(name: 'suggested_priority') @Default('medium') String suggestedPriority,
  }) = _MaintenancePresetModel;

  factory MaintenancePresetModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenancePresetModelFromJson(json);
}
