// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      oneSignalPlayerId: json['onesignal_player_id'] as String?,
      reminderDaysBefore: (json['reminder_days_before'] as num?)?.toInt() ?? 7,
      notifyWarranty: json['notify_warranty'] as bool? ?? true,
      notifyMaintenance: json['notify_maintenance'] as bool? ?? true,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'onesignal_player_id': instance.oneSignalPlayerId,
      'reminder_days_before': instance.reminderDaysBefore,
      'notify_warranty': instance.notifyWarranty,
      'notify_maintenance': instance.notifyMaintenance,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
