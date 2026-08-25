// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_preset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaintenancePresetModel _$MaintenancePresetModelFromJson(
  Map<String, dynamic> json,
) => _MaintenancePresetModel(
  id: json['id'] as String,
  categoryId: json['category_id'] as String,
  presetName: json['preset_name'] as String,
  defaultFrequencyMonths: (json['default_frequency_months'] as num).toInt(),
  suggestedPriority: json['suggested_priority'] as String? ?? 'medium',
);

Map<String, dynamic> _$MaintenancePresetModelToJson(
  _MaintenancePresetModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'category_id': instance.categoryId,
  'preset_name': instance.presetName,
  'default_frequency_months': instance.defaultFrequencyMonths,
  'suggested_priority': instance.suggestedPriority,
};
