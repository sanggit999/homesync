// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServiceLogModel _$ServiceLogModelFromJson(Map<String, dynamic> json) =>
    _ServiceLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      itemId: json['item_id'] as String,
      taskId: json['task_id'] as String?,
      itemName: json['item_name'] as String?,
      serviceType: json['service_type'] as String,
      title: json['title'] as String,
      serviceDate: DateTime.parse(json['service_date'] as String),
      cost: (json['cost'] as num).toDouble(),
      technicianName: json['technician_name'] as String?,
      technicianPhone: json['technician_phone'] as String?,
      receiptImageUrl: json['receipt_image_url'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ServiceLogModelToJson(_ServiceLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'item_id': instance.itemId,
      'task_id': instance.taskId,
      'item_name': instance.itemName,
      'service_type': instance.serviceType,
      'title': instance.title,
      'service_date': instance.serviceDate.toIso8601String(),
      'cost': instance.cost,
      'technician_name': instance.technicianName,
      'technician_phone': instance.technicianPhone,
      'receipt_image_url': instance.receiptImageUrl,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };
