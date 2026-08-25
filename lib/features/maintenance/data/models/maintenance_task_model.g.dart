// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaintenanceTaskModel _$MaintenanceTaskModelFromJson(
  Map<String, dynamic> json,
) => _MaintenanceTaskModel(
  id: json['id'] as String,
  itemId: json['item_id'] as String,
  itemName: json['item_name'] as String?,
  itemLocation: json['item_location'] as String?,
  taskName: json['task_name'] as String,
  frequencyMonths: (json['frequency_months'] as num).toInt(),
  lastCompletedAt: json['last_completed_at'] == null
      ? null
      : DateTime.parse(json['last_completed_at'] as String),
  nextDueDate: DateTime.parse(json['next_due_date'] as String),
  isCompleted: json['is_completed'] as bool? ?? false,
  priority: json['priority'] as String? ?? 'medium',
  technicianName: json['technician_name'] as String?,
  technicianPhone: json['technician_phone'] as String?,
  estimatedCost: (json['estimated_cost'] as num?)?.toDouble(),
  cost: (json['cost'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MaintenanceTaskModelToJson(
  _MaintenanceTaskModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'item_id': instance.itemId,
  'item_name': instance.itemName,
  'item_location': instance.itemLocation,
  'task_name': instance.taskName,
  'frequency_months': instance.frequencyMonths,
  'last_completed_at': instance.lastCompletedAt?.toIso8601String(),
  'next_due_date': instance.nextDueDate.toIso8601String(),
  'is_completed': instance.isCompleted,
  'priority': instance.priority,
  'technician_name': instance.technicianName,
  'technician_phone': instance.technicianPhone,
  'estimated_cost': instance.estimatedCost,
  'cost': instance.cost,
  'notes': instance.notes,
  'created_at': instance.createdAt?.toIso8601String(),
};
