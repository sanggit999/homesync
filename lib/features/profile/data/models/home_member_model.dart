import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_member_model.freezed.dart';
part 'home_member_model.g.dart';

/// Data Model đại diện cho bảng 'home_members' (DTO với Freezed & JsonSerializable)
@freezed
abstract class HomeMemberModel with _$HomeMemberModel {
  const factory HomeMemberModel({
    required String id,
    @JsonKey(name: 'home_id') required String homeId,
    @JsonKey(name: 'user_id') required String userId,
    @Default('member') String role,
    @JsonKey(name: 'user_full_name') String? userFullName,
    @JsonKey(name: 'user_email') String? userEmail,
    @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _HomeMemberModel;

  factory HomeMemberModel.fromJson(Map<String, dynamic> json) =>
      _$HomeMemberModelFromJson(json);
}
