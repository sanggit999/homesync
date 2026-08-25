import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_model.freezed.dart';
part 'home_model.g.dart';

/// Data Model đại diện cho bảng 'homes' (DTO với Freezed & JsonSerializable)
@freezed
abstract class HomeModel with _$HomeModel {
  const factory HomeModel({
    required String id,
    @JsonKey(name: 'owner_id') required String ownerId,
    required String name,
    String? address,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _HomeModel;

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);
}
