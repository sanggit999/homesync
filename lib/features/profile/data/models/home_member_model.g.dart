// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeMemberModel _$HomeMemberModelFromJson(Map<String, dynamic> json) =>
    _HomeMemberModel(
      id: json['id'] as String,
      homeId: json['home_id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String? ?? 'member',
      userFullName: json['user_full_name'] as String?,
      userEmail: json['user_email'] as String?,
      userAvatarUrl: json['user_avatar_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$HomeMemberModelToJson(_HomeMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'home_id': instance.homeId,
      'user_id': instance.userId,
      'role': instance.role,
      'user_full_name': instance.userFullName,
      'user_email': instance.userEmail,
      'user_avatar_url': instance.userAvatarUrl,
      'created_at': instance.createdAt?.toIso8601String(),
    };
