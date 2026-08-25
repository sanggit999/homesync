import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Data Model đại diện cho bảng 'profiles' trên Supabase (DTO với Freezed & JsonSerializable)
@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'onesignal_player_id') String? oneSignalPlayerId,
    @JsonKey(name: 'reminder_days_before') @Default(7) int reminderDaysBefore,
    @JsonKey(name: 'notify_warranty') @Default(true) bool notifyWarranty,
    @JsonKey(name: 'notify_maintenance') @Default(true) bool notifyMaintenance,
    @JsonKey(name: 'is_anonymous') @Default(true) bool isAnonymous,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
